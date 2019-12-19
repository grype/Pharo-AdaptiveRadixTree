"
I am a container node of an adaptive radix tree that contains up to 256 children.

I am the largest type of node. I don't bother with #keys and simply store my #children in a 256 byte array.

#children
#(A B C ... D)
"
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
	tally := tally + 1.
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

	tally := tally - 1.
	tree tallyDown: 1.
	self shrinkIfNecessary.
	^ answer
]

{ #category : #private }
ArtNode256 >> shrink [
	| newNode |

	newNode := ArtNode48 on: tree.
	newNode copyMetaFrom: self.
	newNode tally: 0.
	children
		withIndexDo: [ :each :index | 
			each
				ifNotNil: [ :child | 
					newNode tallyUp.
					child parent: newNode.
					newNode children at: newNode size put: child.
					newNode keys at: index put: newNode size ] ].
	parent replaceChild: self with: newNode.
	self releaseFromTree.
	^ newNode
]
