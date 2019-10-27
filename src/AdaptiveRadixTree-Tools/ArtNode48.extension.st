Extension { #name : #ArtNode48 }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode48 >> childrenWithKeys [
	^ (keys asOrderedCollection
		collectWithIndex: [ :key :index | 
			index
				->
					(key > 0
						ifTrue: [ children at: key ]
						ifFalse: [ nil ]) ])
		select: [ :kv | kv key > 0 and: [ kv value isNotNil ] ]
]
