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
	^ prefix = anObject prefix and: [children = anObject children]
]

{ #category : #adding }
ArtContainerNode >> addChild: aChildNode at: aByte [
	^ self subclassResponsibility 
]

{ #category : #enumerating }
ArtContainerNode >> associationsDo: aBlock [
	children select: #isNotNil thenDo: [ :node | node associationsDo: aBlock ]
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

	| currentDepth mismatchIndex containerNode |

	containerNode := self.
	currentDepth := depth.
	prefixSize > 0
		ifTrue: [ mismatchIndex := self prefixMismatchWith: aKey depth: depth.
			mismatchIndex ~= (prefixSize + 1)
				ifTrue:
					[ containerNode := self splitAtPrefixIndex: mismatchIndex depth: depth.
					containerNode
						addChild:
							((ArtLeafNode on: tree)
								key: aKey;
								value: aValue;
								yourself)
						at: (aKey at: depth + mismatchIndex - 1).
					tree tallyUp: 1.
					^ aValue ].
			currentDepth := currentDepth + prefixSize ].

	^ (containerNode at: (aKey at: currentDepth))
		ifNil: [ containerNode
				addChild:
					((ArtLeafNode on: tree)
						key: aKey;
						value: aValue;
						yourself)
				at: (aKey at: currentDepth).
			tree tallyUp: 1.
			aValue ]
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
	size := aNode size.
	parent := aNode parent.
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

{ #category : #private }
ArtContainerNode >> leafNodes [
	^ self childrenWithKeys select: #isLeaf
]

{ #category : #accessing }
ArtContainerNode >> nodeAt: aKey depth: depth [
	^ (self prefixMismatchWith: aKey depth: depth) ~= (prefixSize + 1)
		ifTrue: [ nil ]
		ifFalse: [ | newDepth |

			newDepth := depth + prefixSize.
			(self at: (aKey at: newDepth))
				ifNotNil: [ :nextNode | nextNode nodeAt: aKey depth: newDepth + 1 ] ]
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
			max to: prefixSize do: [ :i | 
				(minKey at: depth + i) = (aKey at: depth + i)
					ifFalse: [ ^ i + 1 ] ] ].

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
					tree tallyDown: 1.
					val ]
				ifFalse: [ next removeKey: aKey ifAbsent: absentBlock depth: currentDepth + 1 ] ]
]

{ #category : #private }
ArtContainerNode >> replaceChild: aChild with: newChild [
	| index |

	index := children indexOf: aChild.
	newChild parent: self.
	children at: index put: newChild
]

{ #category : #adding }
ArtContainerNode >> shiftChildrenAt: index [
	size + 1 to: index by: -1 do: [ :i | 
		i > 1
			ifTrue: [ children at: i put: (children at: i - 1) ] ].
	children at: size put: nil
]

{ #category : #adding }
ArtContainerNode >> shiftChildrenLargerThan: aByte from: index [
	size to: index by: -1 do: [ :i | 
		| previous |

		previous := keys byteAt: i.
		previous > aByte
			ifTrue: [ keys ifNotNil: [ keys at: i + 1 put: previous ].
				children at: i + 1 put: (children at: i) ] ]
]

{ #category : #adding }
ArtContainerNode >> shiftKeysAtIndex: index [
	size to: index by: -1 do: [ :i | i > 1 ifTrue: [keys at: i put: (keys byteAt: i + 1)] ].
	keys at: size put: 0
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
	| newContainer minKey origSize origPrefix |

	newContainer := ArtNode4 on: tree.
	newContainer prefixSize: anIndex - 1.

	newContainer prefixSize > 0
		ifTrue: [ newContainer
				prefix:
					(prefix
						copyFrom: 1
						to: (anIndex - 1 min: newContainer class maxPrefixSize)) ].

	parent replaceChild: self with: newContainer.
	
	origSize := prefixSize.
	origPrefix := prefix copy.

	prefixSize < self class maxPrefixSize
		ifTrue: [ newContainer addChild: self at: (prefix at: anIndex).
			prefixSize := prefixSize - anIndex.
			prefixSize > 0
				ifTrue: [ prefix := prefix
						copyFrom: anIndex + 1
						to: anIndex + (prefixSize min: self class maxPrefixSize) ] ]
		ifFalse: [ prefixSize := prefixSize - anIndex.
			minKey := self minimum key asByteArray.
			newContainer addChild: self at: (minKey at: depth - 1 + anIndex).
			prefix := minKey
				copyFrom: depth + anIndex
				to: depth - 1 + anIndex + (prefixSize min: self class maxPrefixSize) ].
			
	^ newContainer
]

{ #category : #accessing }
ArtContainerNode >> totalSizeInMemory [
	| total |

	total := self sizeInMemory + prefix sizeInMemory
		+ prefixSize sizeInMemory + size sizeInMemory + keys sizeInMemory
		+ children sizeInMemory.

	children
		ifNotEmpty: [ total := children sum: [ :each | each sizeInMemory ] ].
	^ total
]

{ #category : #enumerating }
ArtContainerNode >> valuesDo: aBlock [
	children select: #isNotNil thenDo: [ :node | node do: aBlock ]
]
