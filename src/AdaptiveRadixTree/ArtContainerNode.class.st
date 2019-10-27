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

{ #category : #accessing }
ArtContainerNode class >> minSize [
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
ArtContainerNode >> addChild: aChildNode at: aByte [
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
ArtContainerNode >> at: aKey depth: depth [
	^ (self prefixMismatchWith: aKey depth: depth) ~= (prefixSize + 1)
		ifTrue: [ nil ]
		ifFalse: [ | newDepth |

			newDepth := depth + prefixSize.
			(self at: (aKey at: newDepth))
				ifNotNil: [ :nextNode | nextNode at: aKey depth: newDepth + 1 ] ]
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
		ifNotNil: [ :nextNode | nextNode at: aKey put: aValue depth: currentDepth + 1 ]
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
	| max |

	max := self class maxPrefixSize min: prefixSize.

	1 to: max do: [ :i | 
		(aKey at: depth - 1 + i) = (prefix at: i)
			ifFalse: [ ^ i ] ].

	prefixSize > self class maxPrefixSize
		ifTrue: [ | minKey |

			minKey := self minimum key.
			max to: minKey size do: [ :i | 
				(minKey at: depth - 1 + i) = (aKey at: depth - 1 + i)
					ifFalse: [ ^ i ] ] ].

	^ prefixSize + 1
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
ArtContainerNode >> removeChildAt: aByte [
	^ self subclassResponsibility 
]

{ #category : #removing }
ArtContainerNode >> removeKey: aKey ifAbsent: absentBlock depth: depth [
	| currentDepth |

	currentDepth := depth.
	prefixSize > 0
		ifTrue: [ (self prefixMismatchWith: aKey depth: depth) ~= (prefixSize + 1)
				ifTrue: [ ^ absentBlock value ]
				ifFalse: [ currentDepth := currentDepth + prefixSize ] ].
			
	^ (self at: (aKey at: currentDepth))
		ifNil: [ absentBlock value ]
		ifNotNil: [ :next | 
			(next isLeaf and: [ next matchesKey: aKey ])
				ifTrue: [ | val |

					val := self removeChildAt: (aKey at: currentDepth).
					ArtCurrentTree value
						ifNotNil: [ :tree | tree removedChildren: 1 ].
					val ]
				ifFalse: [ next removeKey: aKey ifAbsent: absentBlock depth: currentDepth + 1 ] ]
]

{ #category : #adding }
ArtContainerNode >> shiftChildrenAt: index [
	index to: size - 1 do: [ :i | children at: i put: (children at: i + 1) ].
	children at: size put: nil
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

{ #category : #adding }
ArtContainerNode >> shiftKeysAtIndex: index [
	index to: size - 1 do: [ :i | keys byteAt: i put: (keys byteAt: i + 1) ].
	keys byteAt: size put: 0
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

	| nextNode originalPrefix originalPrefixSize fullPrefix nextPrefixStart |

	originalPrefix := prefix.
	originalPrefixSize := prefixSize.

	nextNode := ArtNode node4.
	self become: nextNode.
	
	fullPrefix := originalPrefix.
	nextPrefixStart := anIndex.
	originalPrefixSize > self class maxPrefixSize
		ifTrue: [ fullPrefix := nextNode minimum key.
			nextPrefixStart := depth - 1 + anIndex ].
		
	prefix := fullPrefix copyFrom: 1 to: nextPrefixStart - 1.
	prefixSize := anIndex - 1.

	nextNode prefixSize: nextNode prefixSize - anIndex.

	self addChild: nextNode at: (fullPrefix byteAt: nextPrefixStart).
	nextNode
		prefix:
			(fullPrefix
				copyFrom: nextPrefixStart
				to: nextPrefixStart + nextNode prefixSize - 1).

	nextNode prefixSize > nextNode prefix size
		ifTrue: [ self halt ].
	prefixSize > prefix size
		ifTrue: [ self halt ]
]
