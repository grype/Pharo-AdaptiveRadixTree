Class {
	#name : #ArtNode16,
	#superclass : #ArtContainerNode,
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #accessing }
ArtNode16 class >> maxKeySize [
	^ 16
]

{ #category : #accessing }
ArtNode16 class >> maxSize [
	^ 16
]

{ #category : #accessing }
ArtNode16 class >> minSize [
	^ 5
]

{ #category : #adding }
ArtNode16 >> addChild: aChildNode at: aByte [
	| index |

	self isFull
		ifTrue: [ self grow.
			^ self addChild: aChildNode at: aByte ].

	index := 1.

	self isEmpty
		ifFalse: [ index := keys
				findBinaryIndex: [ :byte | 
					byte >= aByte
						ifTrue: [ 0 ]
						ifFalse: [ -1 ] ]
				ifNone: [ size + 1 ].
			self shiftChildrenLargerThan: aByte from: index ].

	keys byteAt: index put: aByte.
	children at: index put: aChildNode.
	size := size + 1.
	^ aChildNode
]

{ #category : #testing }
ArtNode16 >> grow [
	| newNode index |

	newNode := ArtNode node48.
	newNode copyMetaFrom: self.
	1 to: self size do: [ :i | 
		(self at: i)
			ifNotNil: [ :child | 
				index := 1.
				1 to: newNode children size do: [ :j | (newNode children at: index) ifNotNil: [ index := index + 1 ] ].
				newNode children at: index put: child.
				newNode keys at: (keys at: i) put: index ] ].
	self become: newNode
]

{ #category : #accessing }
ArtNode16 >> indexOf: aKey [
	^ keys
		findBinaryIndex: [ :each | 
			aKey = each
				ifTrue: [ 0 ]
				ifFalse: [ (each ~= 0 and: [ aKey > each ])
						ifTrue: [ 1 ]
						ifFalse: [ -1 ] ] ]
		ifNone: [ 0 ]
]

{ #category : #accessing }
ArtNode16 >> maximum [
	"Returns the right-most leaf node by recursively traversing children using highest byte index"
	^ (children at: size) maximum
]

{ #category : #accessing }
ArtNode16 >> minimum [
	"Returns the left-most leaf node by recursively traversing children using lowest byte index"
	^ (children at: 1) minimum
]

{ #category : #adding }
ArtNode16 >> removeChildAt: aByte [
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