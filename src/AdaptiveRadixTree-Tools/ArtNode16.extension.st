Extension { #name : #ArtNode16 }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode16 >> childrenWithKeys [
	^ ((keys copyFrom: 1 to: self size) asOrderedCollection
		collectWithIndex: [ :key :index | key -> (children at: index) ])
		select: [ :kv | kv key > 0 and: [ kv value isNotNil ] ]
]
