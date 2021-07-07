"
I am a container node of an adaptive radix tree that contains up to 4 children.

I am the smallest containeir node, and I store key-child relationship using two small arrays #keys and #children. Both arrays are maintained sorted - that is, any insertion or removal of children will reorganize the two arrays so that the keys are ordered in ascending manner.

#keys          #children
#(1 2 3 255)   #(A B C D)
"
Class {
	#name : #ArtNode4,
	#superclass : #ArtContainerNode,
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #accessing }
ArtNode4 class >> maxKeySize [
	^ 4
]

{ #category : #accessing }
ArtNode4 class >> maxSize [
	^ 4
]

{ #category : #accessing }
ArtNode4 class >> minSize [
	^ 2
]

{ #category : #adding }
ArtNode4 >> addChild: aChildNode at: aByte [
	| index |

	index := 1.
	self isFull
		ifTrue: [ ^ self grow addChild: aChildNode at: aByte ]
		ifFalse: [ [ index <= tally and: [ aByte >= (keys at: index) ] ]
				whileTrue: [ index := index + 1 ] ].

	tally >= index
		ifTrue: [ keys shiftRight: 1 from: index to: tally.
			children shiftRight: 1 from: index to: tally ].
	keys byteAt: index put: aByte.
	children at: index put: aChildNode.
	aChildNode parent: self.
	tally := tally + 1.
	^ aChildNode
]

{ #category : #iterating }
ArtNode4 >> childrenWithKeys [
	^ ((keys copyFrom: 1 to: self size) asOrderedCollection
		collectWithIndex: [ :key :index | key -> (children at: index) ])
		select: [ :kv | kv key > 0 and: [ kv value isNotNil ] ]
]

{ #category : #testing }
ArtNode4 >> grow [
	| newNode newKeys newChildren |

	newNode := ArtNode16 on: tree.
	newNode copyMetaFrom: self.
	parent replaceChild: self with: newNode.
	newKeys := newNode keys.
	newChildren := newNode children.
	1 to: tally do: [ :i | 
		newKeys byteAt: i put: (keys at: i).
		(newChildren at: i put: (children at: i)) parent: newNode ].
	^ newNode
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
	^ (children at: tally) maximum
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

	answer := children at: index.

	index = tally
		ifTrue: [ keys at: index put: 0.
			children at: index put: nil ]
		ifFalse: [ keys shiftLeft: 1 from: index + 1 to: tally.
			children shiftLeft: 1 from: index + 1 to: tally ].

	keys at: tally put: 0.
	children at: tally put: nil.
	tally := tally - 1.
	tree tallyDown: 1.
	self shrinkIfNecessary.
	^ answer
]

{ #category : #testing }
ArtNode4 >> shrink [
	| newNode currentPrefixSize |

	newNode := children first.
	newNode isLeaf
		ifFalse: [ currentPrefixSize := prefixSize.
			currentPrefixSize < self class maxPrefixSize
				ifTrue: [ currentPrefixSize := currentPrefixSize + 1.
					prefix at: currentPrefixSize put: keys first ].
			currentPrefixSize < self class maxPrefixSize
				ifTrue: [ | childPrefixSize |

					childPrefixSize := newNode prefixSize
						min: self class maxPrefixSize - currentPrefixSize.
					1 to: childPrefixSize do:
						[ :index | prefix at: currentPrefixSize + index put: (newNode prefix at: index) ].
					currentPrefixSize := currentPrefixSize + childPrefixSize ].
			1 to: (currentPrefixSize min: self class maxPrefixSize) do: [ :index | newNode prefix at: index put: (prefix at: index) ].
			newNode prefixSize: newNode prefixSize + prefixSize + 1 ].
	parent replaceChild: self with: newNode.
	self releaseFromTree.
	^ newNode
]
