Class {
	#name : #ArtContainerNode,
	#superclass : #ArtNode,
	#instVars : [
		'children',
		'size',
		'keys',
		'prefix',
		'prefixSize'
	],
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #accessing }
ArtContainerNode class >> maxKeySize [
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtContainerNode class >> maxPrefixSize [
	^ 10
]

{ #category : #accessing }
ArtContainerNode class >> maxSize [
	^ self subclassResponsibility 
]

{ #category : #comparing }
ArtContainerNode >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ children = anObject children
]

{ #category : #adding }
ArtContainerNode >> addChild: aChildNode at: aChar [
	^ self subclassResponsibility
]

{ #category : #accessing }
ArtContainerNode >> at: aKey [
	| index |

	index := self indexOf: aKey.
	^ index > 0
		ifTrue: [ children at: index ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
ArtContainerNode >> at: aKey put: aValue depth: depth [
	"Insert aValue at aKey, starting with given depth. This method is meant to be called recursively.
	 Returns true if a node was actually added (as opposed to updating existing node)."

	| currentDepth mismatchIndex |

	currentDepth := depth.
	prefixSize > 0
		ifTrue: [ mismatchIndex := self prefixMismatchWith: aKey depth: depth.
			mismatchIndex ~= (prefixSize + 1)
				ifTrue: [ self splitAtPrefixIndex: mismatchIndex depth: depth.
					self
						addChild: (ArtNode leafWithKey: aKey value: aValue)
						at: (aKey at: depth + mismatchIndex - 1).
					ArtCurrentTree value ifNotNil: [ :tree | tree addedChildren: 1 ].
					^ aValue ].
			currentDepth := currentDepth + prefixSize ].

	^ (self at: (aKey at: currentDepth))
		ifNil: [ self
				addChild: (ArtNode leafWithKey: aKey value: aValue)
				at: (aKey at: currentDepth).
			ArtCurrentTree value ifNotNil: [ :tree | tree addedChildren: 1 ].
			^ aValue ]
		ifNotNil: [ :nextNode | nextNode at: aKey put: aValue depth: currentDepth ]
]

{ #category : #accessing }
ArtContainerNode >> childNodes [
	^ children select: #isNotNil
]

{ #category : #accessing }
ArtContainerNode >> children [
	^ children
]

{ #category : #copying }
ArtContainerNode >> copyMetaFrom: aNode [
	prefix := aNode prefix copy.
	prefixSize := aNode prefixSize.
	size := aNode size
]

{ #category : #testing }
ArtContainerNode >> grow [
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtContainerNode >> indexOf: aKey [
	^ self subclassResponsibility 
]

{ #category : #initialization }
ArtContainerNode >> initialize [
	| keySize childrenSize |
	super initialize.
	keySize := self class maxKeySize.
	keySize > 0
		ifTrue: [ keys := ByteArray new: keySize ].

	childrenSize := self class maxSize.
	childrenSize > 0
		ifTrue: [ children := Array new: childrenSize ].

	prefix := ByteArray new: self class maxPrefixSize.
	prefixSize := 0.
	size := 0
]

{ #category : #testing }
ArtContainerNode >> isEmpty [
	^ size = 0
]

{ #category : #testing }
ArtContainerNode >> isFull [
	^ self size >= self class maxSize
]

{ #category : #accessing }
ArtContainerNode >> keys [
	^ keys
]

{ #category : #accessing }
ArtContainerNode >> prefix [
	^ prefix
]

{ #category : #accessing }
ArtContainerNode >> prefix: anObject [
	prefix := anObject
]

{ #category : #accessing }
ArtContainerNode >> prefixMismatchWith: aKey depth: depth [
	| maxPrefixSize |

	maxPrefixSize := self class maxPrefixSize.

	prefixSize > maxPrefixSize
		ifTrue: [ ^ aKey
				detectIndex: [ :byte :index | byte ~= (prefix byteAt: index) ]
				from: depth
				to: maxPrefixSize
				ifNone: [ | minKey |

					minKey := self minimum key.
					aKey
						detectIndex: [ :byte :index | byte ~= (minKey at: index) ]
						from: depth
						to: prefixSize
						ifNone: [ prefixSize ] ] ]
		ifFalse: [ ^ aKey
				detectIndex: [ :byte :index | byte ~= (prefix byteAt: index) ]
				from: depth
				to: prefixSize
				ifNone: [ prefixSize + 1 ] ]
]

{ #category : #accessing }
ArtContainerNode >> prefixSize [
	^ prefixSize
]

{ #category : #accessing }
ArtContainerNode >> prefixSize: anObject [
	prefixSize := anObject
]

{ #category : #printing }
ArtContainerNode >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' size: ';
		print: size.
	aStream
		nextPutAll: ' prefixSize: ';
		print: prefixSize.
	aStream
		nextPutAll: ' prefix: ';
		print: prefix.
	aStream
		nextPutAll: ' keys: ';
		print: keys
]

{ #category : #adding }
ArtContainerNode >> shiftChildrenLargerThan: aByte from: index [
	size to: index by: -1 do: [ :i | 
		| previous |

		previous := keys byteAt: i.
		previous > aByte
			ifTrue: [ keys ifNotNil: [ keys byteAt: i + 1 put: previous ].
				children at: i + 1 put: (children at: i) ] ]
]

{ #category : #testing }
ArtContainerNode >> shrink [
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtContainerNode >> size [
	^ size
]

{ #category : #splitjoin }
ArtContainerNode >> splitAtPrefixIndex: anIndex depth: depth [
	"I am going to change into a new node4, split my original prefix and prefix size between the new me and the old me, and have the new me adopt the old me as a child"

	| nextNode wholePrefix wholePrefixSize fullKey fullKeyIndex |

	wholePrefix := prefix.
	wholePrefixSize := prefixSize.

	nextNode := ArtNode node4.
	self become: nextNode.

	prefix := wholePrefix copyFrom: 1 to: anIndex - 1.
	prefixSize := anIndex - 1.

	nextNode prefixSize: wholePrefixSize - anIndex + 1.

	fullKeyIndex := nextNode prefixSize - 1.
	wholePrefixSize > self class maxPrefixSize
		ifTrue: [ fullKey := nextNode minimum key.
			fullKeyIndex := fullKeyIndex + depth + anIndex ]
		ifFalse: [ fullKey := wholePrefix.
			fullKeyIndex := fullKeyIndex + anIndex ].

	nextNode
		prefix:
			(fullKey
				copyFrom: fullKeyIndex
				to: (fullKeyIndex min: self class maxPrefixSize)).
	self addChild: nextNode at: (fullKey byteAt: fullKeyIndex)
]
