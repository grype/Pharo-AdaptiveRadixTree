Extension { #name : #ArtNode }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode >> gtInspectorChildren [

	<inspectorPresentationOrder: 90 title: 'Children'>
	| canvas |
	canvas := RSCanvas new.
	(ArtNodeVisualizer on: canvas) buildWithNode: self.
	^ SpRoassal3InspectorPresenter new
		  canvas: canvas;
		  yourself
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode class >> gtMapViewBuilderFor: node [

	| visualizer |
	visualizer := ArtNodeVisualizer new.
	visualizer buildWithNode: node.
	^ visualizer canvas
]
