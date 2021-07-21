Class {
	#name : #ArtNodeVisualizer,
	#superclass : #Object,
	#instVars : [
		'canvas'
	],
	#category : #'AdaptiveRadixTree-Tools'
}

{ #category : #'instance creation' }
ArtNodeVisualizer class >> on: aCanvas [

	^ self basicNew initializeWithCanvas: aCanvas
]

{ #category : #building }
ArtNodeVisualizer >> buildMenuOn: aMenu for: element [
]

{ #category : #building }
ArtNodeVisualizer >> buildWithNode: node [

	| map nodes popup |
	map := node allChildrenWithKeys.
	nodes := node allNodes
		         collect: [ :aNode | 
			         self elementForNode: aNode text: (map
					          detect: [ :assoc | assoc value == aNode ]
					          ifFound: [ :assoc | assoc key asCharacter asString ]
					          ifNone: [ '' ]) ]
		         as: RSGroup.

	canvas color: Smalltalk ui theme darkBaseColor.
	canvas addAll: nodes.

	nodes @ (RSMenuActivable new menuDo: [ :menu :element | 
		 self buildMenuOn: menu for: element  ]).

	popup := RSPopup text: [ :aNode | self popupTextForNode: aNode ].
	nodes @ popup @ RSDraggable.

	RSLineBuilder horizontalBezier
		attachPoint: RSHorizontalAttachPoint new;
		canvas: canvas;
		shapes: nodes;
		width: 1;
		connectFrom: #parent.

	RSHorizontalTreeLayout new
		horizontalGap: 20;
		on: nodes.

	canvas @ RSCanvasController
]

{ #category : #accessing }
ArtNodeVisualizer >> canvas [

	^ canvas
]

{ #category : #'private - utilities' }
ArtNodeVisualizer >> elementForNode: aNode text: text [

	| g label |
	g := RSGroup new.
	g add: (RSCircle new
			 size: 10;
			 color: (self shapeColorForNode: aNode);
			 borderColor: Color gray;
			 yourself).
	label := RSLabel new
		         fontSize: 5;
		         text: text;
		         color: (self textColorForNode: aNode);
		         yourself.

	g add: label.
	^ aNode isLeaf
		  ifTrue: [ 
			  | gg |
			  gg := RSGroup new.
			  gg add: g asShape.
			  gg add: (RSLabel new
					   fontSize: 5;
					   text: aNode key asString;
					   color: Smalltalk ui theme textColor;
					   yourself).
			  RSHorizontalLineLayout new
				  gapSize: 2;
				  on: gg.
			  gg asShapeFor: aNode ]
		  ifFalse: [ g asShapeFor: aNode ]
]

{ #category : #initialization }
ArtNodeVisualizer >> initialize [

	super initialize.
	canvas := RSCanvas new.
	canvas color: Smalltalk ui theme backgroundColor
]

{ #category : #initialization }
ArtNodeVisualizer >> initializeWithCanvas: aCanvas [
	self initialize.
	canvas := aCanvas 
]

{ #category : #building }
ArtNodeVisualizer >> popupTextForNode: aNode [

	| children |
	^ aNode isLeaf
		  ifTrue: [ aNode value asString ]
		  ifFalse: [ 
			  children := aNode allNodes copyWithout: aNode.
			  children := children first: (children size min: 10).
			  (children collect: [ :n | n value asString ]) joinUsing:
				  Character cr ]
]

{ #category : #'private - utilities' }
ArtNodeVisualizer >> shapeColorForNode: aNode [

	^ aNode isLeaf
		ifTrue: [ Color gray ]
		ifFalse: [ Color transparent ]
]

{ #category : #'private - utilities' }
ArtNodeVisualizer >> textColorForNode: aNode [

	^ aNode isLeaf
		ifTrue: [ Smalltalk ui theme textColor ]
		ifFalse: [ Color gray ]
]
