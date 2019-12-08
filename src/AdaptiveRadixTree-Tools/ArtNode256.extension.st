Extension { #name : #ArtNode256 }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode256 >> childrenWithKeys [
	^ (children asOrderedCollection
		collectWithIndex: [ :key :index | (index - 1) -> (children at: index) ])
		select: [ :kv | kv key > 0 and: [ kv value isNotNil ] ]
]
