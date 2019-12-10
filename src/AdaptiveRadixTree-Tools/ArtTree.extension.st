Extension { #name : #ArtTree }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtTree >> gtInspectorMapIn: composite [
	<gtInspectorPresentationOrder: 90>
	composite roassal2
		title: [ 'Map' translated ];
		when: [ root isNotNil ];
		initializeView: [ ArtNode gtMapViewBuilder value: root ]
]
