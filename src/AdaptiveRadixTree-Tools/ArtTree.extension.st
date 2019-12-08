Extension { #name : #ArtTree }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtTree >> gtInspectorIn: composite [
	<gtInspectorPresentationOrder: 90>
	composite roassal2
		title: [ 'Map' translated ];
		when: [ root isNotNil ];
		initializeView: [ ArtNode gtMapViewBuilder value: root ]
]
