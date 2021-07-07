"
I am a container node of an adaptive radix tree that contains up to 48 children.

I store references to #children in a small array, and use #keys to map keys to indecies into that array.

#keys             #children
#(1 2 3 ... 256)  #(A B C ... D)
"
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
		ifTrue: [ ^ self grow addChild: aChildNode at: aByte ].

	index := children detectIndex: [ :child | child isNil ].
	children at: index put: aChildNode.
	keys byteAt: aByte + 1 put: index.
	aChildNode parent: self.
	tally := tally + 1.
	^ aChildNode
]

{ #category : #iterating }
ArtNode48 >> childrenWithKeys [
	^ (keys asOrderedCollection
		collectWithIndex: [ :key :index | 
			index - 1
				->
					(key > 0
						ifTrue: [ children at: key ]
						ifFalse: [ nil ]) ])
		select: [ :kv | kv key > 0 and: [ kv value isNotNil ] ]
]

{ #category : #testing }
ArtNode48 >> grow [
	| newNode newChildren |

	newNode := ArtNode256 on: tree.
	newNode copyMetaFrom: self.
	newChildren := newNode children.
	1 to: keys size do: [ :i | 
		(self at: i - 1)
			ifNotNil: [ :child | 
				child parent: newNode.
				newChildren at: i put: child ] ].
	parent replaceChild: self with: newNode.
	^ newNode
]

{ #category : #accessing }
ArtNode48 >> indexOf: aKey [
	^ keys at: aKey + 1 ifAbsent: [ 0 ]
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
		detectIndex: [ :byte | byte ~= 0 ]
		ifNone: [ keys size ].
	^ (children at: (keys at: index)) minimum
]

{ #category : #adding }
ArtNode48 >> removeChildAt: aByte [
	| answer index |

	answer := nil.
	index := self indexOf: aByte.
	index > 0
		ifFalse: [ ^ answer ].

	keys at: aByte + 1 put: 0.
	answer := children at: index.
	children at: index put: nil.

	tally := tally - 1.
	tree tallyDown: 1.
	self shrinkIfNecessary.
	^ answer
]

{ #category : #private }
ArtNode48 >> shrink [
	| newNode |

	newNode := ArtNode16 on: tree.
	newNode copyMetaFrom: self.
	newNode tally: 0.
	keys
		withIndexDo: [ :childIndex :byte | 
			childIndex > 0
				ifTrue: [ (children at: childIndex)
						ifNotNil: [ :child | 
							newNode tallyUp.
							newNode keys at: newNode size put: byte - 1.
							newNode children at: newNode size put: child.
							child parent: newNode ] ] ].
	parent replaceChild: self with: newNode.
	self releaseFromTree.
	^ newNode
]
