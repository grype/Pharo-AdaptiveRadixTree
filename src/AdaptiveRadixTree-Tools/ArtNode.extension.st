Extension { #name : #ArtNode }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode >> gtInspectorMapIn: composite [

	<gtInspectorPresentationOrder: -10>
	<inspectorPresentationOrder: 999 title: 'Map'>
	^ composite roassal3
		  title: 'Map';
		  initializeCanvas: [ self class gtMapViewBuilderFor: self ]
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode >> gtInspectorParentIn: composite [

	<gtInspectorPresentationOrder: 20>
	<inspectorPresentationOrder: 999 title: 'Parent'>
	^ composite roassal3
		  title: 'Parent';
		  when: [ parent isNotNil ];
		  initializeCanvas: [ self class gtMapViewBuilderFor: parent ]
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode class >> gtMapViewBuilderFor: node [

	| visualizer |
	visualizer := ArtNodeVisualizer new.
	visualizer buildWithNode: node.
	^ visualizer canvas
]
