Class {
	#name : #ArtNode4,
	#superclass : #ArtContainerNode,
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #adding }
ArtNode4 >> addChild: aChildNode at: aByte [
	| index |

	self isFull
		ifTrue: [ self grow.
			^ self addChild: aChildNode at: aByte ].

	index := 1.

	self isEmpty
		ifFalse: [ index := keys
				detectIndex: [ :each :i | aByte < each ]
				from: 1
				to: size
				ifNone: [ size + 1 ].
			self shiftChildrenLargerThan: aByte from: index ].

	keys byteAt: index put: aByte.
	children at: index put: aChildNode.
	size := size + 1.
	^ aChildNode
]

{ #category : #testing }
ArtNode4 >> grow [
	| newNode |

	newNode := ArtNode node16.
	newNode copyMetaFrom: self.
	1 to: size do: [ :i | 
		newNode keys at: i put: (keys at: i).
		newNode children at: i put: (children at: i) ].
	self become: newNode
]

{ #category : #comparing }
ArtNode4 >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ children hash
]

{ #category : #accessing }
ArtNode4 >> indexOf: aKey [
	^ keys indexOf: aKey
]

{ #category : #accessing }
ArtNode4 >> maximum [
	"Returns the right-most leaf node by recursively traversing children using highest byte index"
	^ (children at: size) maximum
]

{ #category : #accessing }
ArtNode4 >> minimum [
	"Returns the left-most leaf node by recursively traversing children using lowest byte index"
	^ (children at: 1) minimum
]

{ #category : #adding }
ArtNode4 >> removeChildAt: aByte [
	| answer index |

	answer := nil.
	index := self indexOf: aByte.
	index > 0
		ifFalse: [ ^ answer ].

	keys byteAt: index put: 0.
	answer := children at: index.
	children at: index put: nil.

	self shiftKeysAtIndex: index.
	self shiftChildrenAt: index.

	size := size - 1.
	^ answer
]
