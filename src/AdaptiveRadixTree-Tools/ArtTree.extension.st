Extension { #name : #ArtTree }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtTree >> gtInspectorIndex [

	<inspectorPresentationOrder: 90 title: 'Index'>
	^ self root gtInspectorChildren
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtTree >> gtLeaves [

	<inspectorPresentationOrder: 91 title: 'Leaves'>
	^ self root gtLeaves 
]
