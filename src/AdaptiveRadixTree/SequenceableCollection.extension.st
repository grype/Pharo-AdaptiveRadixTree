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
SequenceableCollection >> withIndexDo: elementAndIndexBlock from: startIndex to: endIndex [
	"Just like withIndexDo: but starting at given index "

	startIndex to: endIndex do: [ :index | elementAndIndexBlock value: (self at: index) value: index ]
]

{ #category : #'*AdaptiveRadixTree' }
SequenceableCollection >> withIndexDo: elementAndIndexBlock startingAt: startIndex [
	"Just like withIndexDo: but starting at given index "

	startIndex to: self size do: [ :index | elementAndIndexBlock value: (self at: index) value: index ]
]
