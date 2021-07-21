Extension { #name : #ArtNode }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode >> gtInspectorChildren [

	<inspectorPresentationOrder: 90 title: 'Children'>
	^ SpRoassalPresenter new
		  script: [ :canvas | 
			  (ArtNodeVisualizer on: canvas) buildWithNode: self ];
		  yourself
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode class >> gtMapViewBuilderFor: node [

	| visualizer |
	visualizer := ArtNodeVisualizer new.
	visualizer buildWithNode: node.
	^ visualizer canvas
]
