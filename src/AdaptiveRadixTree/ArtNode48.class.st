Class {
	#name : #ArtNode48,
	#superclass : #ArtContainerNode,
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #accessing }
ArtNode48 class >> maxKeySize [
	^ 256
]

{ #category : #accessing }
ArtNode48 class >> maxSize [
	^ 48
]

{ #category : #accessing }
ArtNode48 class >> minSize [
	^ 17
]

{ #category : #adding }
ArtNode48 >> addChild: aChildNode at: aByte [
	| index |

	self isFull
		ifTrue: [ self grow.
			^ self addChild: aChildNode at: aByte ].

	index := children detectIndex: [ :child | child isNil ].
	children at: index put: aChildNode.
	keys at: aByte put: index.
	size := size + 1.
	^ aChildNode
]

{ #category : #testing }
ArtNode48 >> grow [
	| newNode |

	newNode := ArtNode node256.
	newNode copyMetaFrom: self.
	1 to: keys size do:
		[ :i | (self at: i) ifNotNil: [ :child | newNode children at: i put: child ] ].
	self become: newNode
]

{ #category : #accessing }
ArtNode48 >> indexOf: aKey [
	^ keys at: aKey
]

{ #category : #accessing }
ArtNode48 >> maximum [
	"Returns the right-most leaf node by recursively traversing children using highest byte index"

	| index |

	index := keys detectIndex: [ :byte | byte = 0 ] ifNone: [ ^ nil ].
	index > 1
		ifFalse: [ ^ nil ].
	^ (children at: index - 1) maximum
]

{ #category : #accessing }
ArtNode48 >> minimum [
	"Returns the left-most leaf node by recursively traversing children using lowest byte index"

	| index |

	index := keys
		detectIndex: [ :byte :i | (keys at: i) ~= 0 ]
		ifNone: [ keys size ].
	^ (children at: index) minimum
]

{ #category : #adding }
ArtNode48 >> removeChildAt: aByte [
	| answer index |

	answer := nil.
	index := self indexOf: aByte.
	index > 0
		ifFalse: [ ^ answer ].

	keys byteAt: aByte put: 0.
	answer := children at: index.
	children at: index put: nil.

	size := size - 1.
	^ answer
]

{ #category : #'private-adding' }
ArtNode48 >> removeKeyAtIndex: index [

]
