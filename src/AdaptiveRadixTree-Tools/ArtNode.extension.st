Extension { #name : #ArtNode }

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode >> allChildrenWithKeys [
	^ self childrenWithKeys
		flatCollect: [ :kv | 
			(kv value isKindOf: ArtContainerNode)
				ifTrue: [ OrderedCollection new
						add: kv;
						addAll: kv value allChildrenWithKeys;
						yourself ]
				ifFalse: [ {kv} ] ]
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode >> childrenWithKeys [
	^ self subclassResponsibility
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode >> gtInspectorMapIn: composite [
	<gtInspectorPresentationOrder: 10>
	| b |

	composite roassal2
		title: 'Map';
		initializeView: [ self class gtMapViewBuilder value: self ]
]

{ #category : #'*AdaptiveRadixTree-Tools' }
ArtNode class >> gtMapViewBuilder [
	^ [ :root | 
	| b map |

	map := root allChildrenWithKeys.
	b := RTInteractiveTreeBuilder new.
	b shape
		withText: [ :node | 
			map
				detect: [ :assoc | assoc value == node ]
				ifFound: [ :assoc | assoc key asCharacter asString ]
				ifNone: [ '' ] ].
	b view canvas color: (Color colorFrom: '#EEE').
	b
		explore: root
		using: [ :node | 
			node isLeaf
				ifTrue: [ Array new ]
				ifFalse: [ 
					node childrenWithKeys collect: #value
					"node childNodes "
					] ].

	b labelShape text
		text: [ :node | 
			node isLeaf
				ifTrue: [ node key allButLast asString , ':' , node value ]
				ifFalse: [ node prefixSize > 0
						ifTrue: [ node prefixSize > node class maxPrefixSize
								ifTrue: [ (node prefix copyFrom: 1 to: node class maxPrefixSize) asString , '+' ]
								ifFalse: [ node prefix copyFrom: 1 to: node prefixSize ] ]
						ifFalse: [ '' ] ] ].
	b rightward.
	b verticalGap: 20.
	b build.
	b view ]
]
