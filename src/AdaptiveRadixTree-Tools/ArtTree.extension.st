Extension { #name : #ArtTree }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtTree >> gtInspectorIn: composite [
	<gtInspectorPresentationOrder: 10>
	| b |

	composite roassal2
		title: 'Map';
		when: [ root isNotNil ];
		initializeView: [ ArtNode gtMapViewBuilder value: root ]
]
