Extension { #name : #ByteArray }

{ #category : #'*AdaptiveRadixTree' }
ByteArray >> nullTerminated [
	^ self copyWith: 0
]
