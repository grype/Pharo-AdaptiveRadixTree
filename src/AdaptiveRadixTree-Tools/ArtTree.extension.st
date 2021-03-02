Extension { #name : #ArtTree }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtTree >> gtInspectorMapIn: composite [
	<gtInspectorPresentationOrder: 90>
	composite roassal3
		title: [ 'Map' translated ];
		when: [ root isNotNil ];
		initializeCanvas: [ ArtNode gtMapViewBuilderFor: root ]
]
