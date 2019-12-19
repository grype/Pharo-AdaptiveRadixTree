"
I am a container node of an adaptive radix tree that contains up to 16 children.

I am very much like ==ArtNode4== except my #keys and #children arrays are four times larger.
"
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

	index := 1.
	self isFull
		ifTrue: [ ^ self grow addChild: aChildNode at: aByte ]
		ifFalse: [ index := keys
				findBinaryIndex: [ :byte | 
					(byte > aByte)
						ifTrue: [ -1 ]
						ifFalse: [ 1 ] ]
				from: 1
				to: self size
				do: [ :found | found ]
				ifNone: [ :low :high | high ].
			index <= tally
				ifTrue: [ 
					self shiftChildrenLargerThan: aByte from: index
					] ].

	keys byteAt: index put: aByte.
	children at: index put: aChildNode.
	aChildNode parent: self.
	tally := tally + 1.
	^ aChildNode
]

{ #category : #testing }
ArtNode16 >> grow [
	| newNode index newKeys newChildren |

	newNode := ArtNode48 on: tree.
	newNode copyMetaFrom: self.
	parent replaceChild: self with: newNode.
	newKeys := newNode keys.
	newChildren := newNode children.
	1 to: self size do: [ :i | 
		(children at: i)
			ifNotNil: [ :child | 
				index := 1.
				1 to: newNode children size do: [ :j | (newNode children at: index) ifNotNil: [ index := index + 1 ] ].
				(newChildren at: index put: child) parent: newNode.
				newKeys byteAt: (keys at: i) + 1 put: index ] ].
	^ newNode
]

{ #category : #accessing }
ArtNode16 >> indexOf: aKey [
	^ keys
		findBinaryIndex: [ :each | 
			aKey = each
				ifTrue: [ 0 ]
				ifFalse: [ (aKey > each)
						ifTrue: [ 1 ]
						ifFalse: [ -1 ] ] ]
		from: 1
		to: self size
		do: [ :found | found ]
		ifNone: [ 0 ]
]

{ #category : #accessing }
ArtNode16 >> maximum [
	"Returns the right-most leaf node by recursively traversing children using highest byte index"
	^ (children at: tally) maximum
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

	answer := children at: index.

	index = tally
		ifTrue: [ keys at: index put: 0.
			children at: index put: nil ]
		ifFalse: [ keys shiftLeft: 1 from: index + 1 to: tally.
			children shiftLeft: 1 from: index + 1 to: tally ].

	tally := tally - 1.
	tree tallyDown: 1.
	self shrinkIfNecessary.
	^ answer
]

{ #category : #private }
ArtNode16 >> shrink [
	| newNode newSize |

	newNode := ArtNode4 on: tree.
	newNode copyMetaFrom: self.
	newSize := newNode keys size.
	1 to: newSize do: [ :i | 
		| child |

		child := children at: i.
		child parent: newNode.
		newNode children at: i put: child.
		newNode keys at: i put: (keys at: i) ].
	newNode tally: newSize.
	parent replaceChild: self with: newNode.
	self releaseFromTree.
	^ newNode
]
