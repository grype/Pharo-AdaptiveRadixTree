Class {
	#name : #ArtNode256,
	#superclass : #ArtContainerNode,
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #accessing }
ArtNode256 class >> maxKeySize [
	^ 0
]

{ #category : #accessing }
ArtNode256 class >> maxSize [
	^ 256
]

{ #category : #accessing }
ArtNode256 class >> minSize [
	^ 49
]

{ #category : #adding }
ArtNode256 >> addChild: aChildNode at: aByte [
	children at: aByte + 1 put: aChildNode.
	aChildNode parent: self.
	size := size + 1.
	^ aChildNode
]

{ #category : #testing }
ArtNode256 >> grow [
	"I cannot grow"
	^ self
]

{ #category : #accessing }
ArtNode256 >> indexOf: aKey [
	^ aKey + 1
]

{ #category : #accessing }
ArtNode256 >> maximum [
	(children size to: 1 by: -1)
		do: [ :i | (children at: i) ifNotNil: [ :node | node maximum ] ].
		
	^ nil
]

{ #category : #accessing }
ArtNode256 >> minimum [
	"Returns the left-most leaf node by recursively traversing children using lowest byte index"

	| index |

	index := children
		detectIndex: [ :each :i | (children at: i) isNotNil ]
		ifNone: [ keys size ].
	^ (children at: index) minimum
]

{ #category : #adding }
ArtNode256 >> removeChildAt: aByte [
	| answer index |

	answer := nil.
	index := self indexOf: aByte.
	index > 0
		ifFalse: [ ^ answer ].

	answer := children at: index.
	children at: index put: nil.

	size := size - 1.
	^ answer
]
