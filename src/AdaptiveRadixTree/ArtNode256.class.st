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

{ #category : #adding }
ArtNode256 >> addChild: aChildNode at: aByte [
	self isFull
		ifTrue: [ ArtAddChildError signal: 'Tried to add a child to a node that is full and cannot grow' node: self.
			^ nil ].
	children at: aByte put: aChildNode.
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
	^ aKey
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
