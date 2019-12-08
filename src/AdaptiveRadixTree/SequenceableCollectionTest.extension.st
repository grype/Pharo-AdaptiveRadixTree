Extension { #name : #SequenceableCollectionTest }

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollectionTest >> testShiftLeftFromTo [

	(#(1 2 3 4) shiftLeft: 1 from: 2 to: 4) should equal: #(2 3 4 4).
	(#(1 2 3 4) shiftLeft: 2 from: 3 to: 4) should equal: #(3 4 3 4).

	(#(1 2 3 4 5 6) shiftLeft: 1 from: 2 to: 6) should equal: #(2 3 4 5 6 6).
	(#(1 2 3 4 5 6) shiftLeft: 1 from: 4 to: 5) should equal: #(1 2 4 5 5 6).
	
	(#(1 2) shiftLeft: 1 from: 2 to: 2) should equal: #(2 2).
	(#(1 2 3) shiftLeft: 1 from: 2 to: 2) should equal: #(2 2 3)
]

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollectionTest >> testShiftRightFromTo [
	(#(1 2 3 4) shiftRight: 1 from: 1 to: 3) should equal: #(1 1 2 3).
	(#(1 2 3 4) shiftRight: 2 from: 1 to: 2) should equal: #(1 1 1 2).

	(#(1 2 3 4 5 6) shiftRight: 1 from: 1 to: 5) should
		equal: #(1 1 2 3 4 5).
	(#(1 2 3 4 5 6) shiftRight: 1 from: 4 to: 5) should
		equal: #(1 2 3 4 4 5).

	(#(1 2) shiftRight: 1 from: 1 to: 1) should equal: #(1 1).
	(#(1 2 3) shiftRight: 1 from: 2 to: 2) should equal: #(1 2 2)
]
