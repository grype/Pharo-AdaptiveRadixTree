Extension { #name : #ArtNode }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode >> gtInspectorIndex [

	<inspectorPresentationOrder: 999 title: 'Index'>
	^ SpRoassalPresenter new
		  script: [ :canvas | 
			  (ArtNodeVisualizer on: canvas) buildWithNode: self ];
		  yourself
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode >> gtInspectorParent [

	<inspectorPresentationOrder: 999 title: 'Parent'>
	^ SpRoassalPresenter new
		  script: [ :canvas | 
			  (parent isKindOf: ArtNode) ifTrue: [ 
					  (ArtNodeVisualizer on: canvas) buildWithNode: parent ] ];
		  yourself
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode class >> gtMapViewBuilderFor: node [

	| visualizer |
	visualizer := ArtNodeVisualizer new.
	visualizer buildWithNode: node.
	^ visualizer canvas
]
