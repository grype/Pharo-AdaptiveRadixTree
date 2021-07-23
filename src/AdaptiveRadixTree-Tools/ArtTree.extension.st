Extension { #name : #ArtTree }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtTree >> gtInspectorTree [

	<inspectorPresentationOrder: 90 title: 'Tree'>
	^ self root gtInspectorChildren
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtTree >> gtLeaves [

	<inspectorPresentationOrder: 91 title: 'Leaves'>
	^ self root gtLeaves 
]
