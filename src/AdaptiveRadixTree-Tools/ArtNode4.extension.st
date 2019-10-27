Extension { #name : #ArtNode4 }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode4 >> childrenWithKeys [
	^ (keys asOrderedCollection
		collectWithIndex: [ :key :index | key -> (children at: index) ])
		select: [ :kv | kv key > 0 and: [ kv value isNotNil ] ]
]
