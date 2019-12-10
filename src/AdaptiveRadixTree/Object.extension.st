Extension { #name : #Object }

{ #category : #'*AdaptiveRadixTree' }
Object >> asArtTree [
	"Answer an OrderedCollection with the receiver as its only element."

	^ ArtTree with: self
]
