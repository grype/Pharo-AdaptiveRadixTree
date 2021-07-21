Extension { #name : #ArtContainerNode }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtContainerNode >> gtLeaves [

	<inspectorPresentationOrder: 91 title: 'Leaves'>
	^ SpListPresenter new
		  items:
			  ((self allNodes select: [ :aNode | aNode isLeaf ]) collect:
					   #value);
		  display: [ :each | each printString ];
		  beMultipleSelection;
		  yourself
]
