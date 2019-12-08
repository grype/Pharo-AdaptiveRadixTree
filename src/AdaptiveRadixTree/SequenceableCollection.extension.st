Extension { #name : #SequenceableCollection }

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollection >> detectIndex: aBlock from: startIndex to: endIndex ifNone: exceptionBlock [
	self
		withIndexDo: [ :each :index | 
			(aBlock value: each value: index)
				ifTrue: [ ^ index ] ]
		from: startIndex
		to: endIndex.
	^ exceptionBlock value
]

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollection >> detectIndex: aBlock startingAt: startIndex ifNone: exceptionBlock [ 

	self withIndexDo: [:each :index | (aBlock value: each) ifTrue: [^ index]] startingAt: startIndex.
	^ exceptionBlock value
]

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollection >> findBinaryIndex: aBlock from: start to: end do: actionBlock ifNone: exceptionBlock [
	"Search for an element in the receiver using binary search.
	The argument aBlock is a one-element block returning
		0 	- if the element is the one searched for
		<0	- if the search should continue in the first half
		>0	- if the search should continue in the second half
	If found, evaluate actionBlock with the index as argument
	If no matching element is found, evaluate exceptionBlock,
	with the indexes of the 'bounding' elements as arguments.
	Warning: Might give invalid indexes, see examples below
	Examples:
		#(1 3 5 7 11 15 23)
			findBinaryIndex: [ :arg | 11 - arg ]
			do: [ :found | found ]
			ifNone: [ :a :b | 'between: ', {a. b} printString ]
		#(1 3 5 7 11 15 23)
			findBinaryIndex: [ :arg | 12 - arg ]
			do: [ :found | found ]
			ifNone: [ :a :b | 'between: ', {a. b} printString ]
		#(1 3 5 7 11 15 23)
			findBinaryIndex: [ :arg | 0.5 - arg ]
			do: [ :found | found ]
			ifNone: [ :a :b | 'between: ', {a. b} printString ]
		#(1 3 5 7 11 15 23)
			findBinaryIndex: [ :arg | 25 - arg ]
			do: [ :found | found ]
			ifNone: [ :a :b | 'between: ',{a. b} printString ] "
			
	| index low high test |
	low := start.
	high := end.
	[ index := high + low // 2.
	  low > high ] whileFalse: [
		test := aBlock value: (self at: index).
		test = 0 
			ifTrue: [ ^ actionBlock value: index ]
			ifFalse: [ test > 0
				ifTrue: [ low := index + 1 ]
				ifFalse: [ high := index - 1 ] ] ].
	^ exceptionBlock cull: high cull: low
]

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollection >> longestCommonPrefixWith: anotherCollection startingAt: anIndex [
	| count |
	count := 0.
	anIndex to: (self size min: anotherCollection size) do: [ :index | 
		(self at: index) = (anotherCollection at: index)
			ifTrue: [ count := count + 1 ]
			ifFalse: [ ^ count ] ].
	^ count
]

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollection >> shiftLeft: count from: firstIndex to: lastIndex [
	firstIndex to: lastIndex by: count do: [ :index | self at: index - count put: (self at: index) ]
]

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollection >> shiftRight: count from: firstIndex to: lastIndex [
	lastIndex + count to: firstIndex + count by: 0 - count do: [ :index | self at: index put: (self at: index - count) ]
]

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollection >> withIndexDo: elementAndIndexBlock from: startIndex to: endIndex [
	"Just like withIndexDo: but starting at given index "

	startIndex to: endIndex do: [ :index | elementAndIndexBlock value: (self at: index) value: index ]
]

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollection >> withIndexDo: elementAndIndexBlock startingAt: startIndex [
	"Just like withIndexDo: but starting at given index "

	startIndex to: self size do: [ :index | elementAndIndexBlock value: (self at: index) value: index ]
]
