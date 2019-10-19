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

{ #category : #adding }
ArtNode48 >> addChild: aChildNode at: aByte [
	| index |

	self isFull
		ifTrue: [ self grow.
			^ self addChild: aChildNode at: aByte ].

	index := children detectIndex: [ :child | child isNil ].
	children at: index put: aChildNode.
	keys at: aByte put: index.
	size := size + 1
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
ArtNode48 >> minimum [
	"Returns the left-most leaf node by recursively traversing children using lowest byte index"

	| index |

	index := keys
		detectIndex: [ :byte :i | (keys at: i) ~= 0 ]
		ifNone: [ keys size ].
	^ (children at: index) minimum
]
