Extension { #name : #ArtNode16 }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode16 >> childrenWithKeys [
	^ (keys asOrderedCollection
		collectWithIndex: [ :key :index | key -> (children at: index) ])
		select: [ :kv | kv key > 0 and: [ kv value isNotNil ] ]
]
