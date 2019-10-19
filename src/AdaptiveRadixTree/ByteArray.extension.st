Extension { #name : #ByteArray }

{ #category : #'*AdaptiveRadixTree' }
ByteArray >> ensureNullTerminated [
	self last = 0
		ifFalse: [ | newArray |

			newArray := self copyWith: 0.
			self become: newArray ].
	^ self
]
