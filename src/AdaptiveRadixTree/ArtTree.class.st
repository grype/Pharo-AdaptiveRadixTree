Class {
	#name : #ArtTree,
	#superclass : #Dictionary,
	#instVars : [
		'root'
	],
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #'instance creation' }
ArtTree class >> newFrom: aCollection [
	"Answer an instance of me containing the same elements as aCollection."
	| newCollection |
	newCollection := self new.
	newCollection addAll: aCollection.
	^ newCollection
"
	ArtTree newFrom: {1. 2. 3}
	{1. 2. 3} as: ArtTree
"
]

{ #category : #'instance creation' }
ArtTree class >> withAll: aCollection [
	"Create a new collection containing all the elements from aCollection."

	^ (self new)
		addAll: aCollection;
		yourself
]

{ #category : #adding }
ArtTree >> add: anAssociation [
	self at: anAssociation key put: anAssociation value
]

{ #category : #accessing }
ArtTree >> allNodes [
	| collection |

	collection := OrderedCollection new.
	root
		ifNotNil:
			[ :node | node withAllChildNodesDo: [ :each | collection add: each ] ].

	^ collection
]

{ #category : #converting }
ArtTree >> asArtTree [
	^ self species == ArtTree
		ifTrue: [ self ]
		ifFalse: [ super asArtTree ]
]

{ #category : #adding }
ArtTree >> associationAt: key ifAbsent: aBlock [
	^ (self nodeAt: key)
		ifNil: [ aBlock value ]
		ifNotNil: [ :node | node key -> node value ]
]

{ #category : #adding }
ArtTree >> associationAt: key ifPresent: aBlock [
	^ (self nodeAt: key)
		ifNotNil: [ :node | aBlock cull: node key -> node value ]
]

{ #category : #enumerating }
ArtTree >> associationsDo: aBlock [
	root ifNil: [ ^ self ].
	root associationsDo: aBlock
]

{ #category : #'nested dictionaries' }
ArtTree >> at: firstKey at: secondKey [
	^ self shouldNotImplement 
]

{ #category : #'nested dictionaries' }
ArtTree >> at: firstKey at: secondKey ifAbsent: aZeroArgBlock [
	^ self shouldNotImplement 
]

{ #category : #'nested dictionaries' }
ArtTree >> at: firstKey at: secondKey ifAbsentPut: aZeroArgBlock [
	^ self shouldNotImplement 
]

{ #category : #'nested dictionaries' }
ArtTree >> at: firstKey at: secondKey put: aValue [
	^ self shouldNotImplement 
]

{ #category : #accessing }
ArtTree >> at: key ifAbsent: aBlock [
	^ (root
		ifNotNil: [ :node | node at: key asByteArray ensureNullTerminated depth: 1 ])
		ifNil: [ aBlock value ]
]

{ #category : #accessing }
ArtTree >> at: aKey ifAbsentPut: aBlock [
	^ self at: aKey ifAbsent: [ self at: aKey put: aBlock value ]
]

{ #category : #accessing }
ArtTree >> at: aKey ifPresent: aBlock [
	^ (root ifNotNil: [ :node | node at: aKey ]) ifNotNil: aBlock
]

{ #category : #accessing }
ArtTree >> at: aKey put: aValue [
	"Puts given value at given key. If a leaf node matching the key exists - its value is updated, otherwise - a new leaf node is created, manipulating intemediate node structure if needed. Returns inserted value"

	| key |

	aKey size > 0
		ifFalse: [ ^ self ].
	key := aKey asByteArray ensureNullTerminated.
	^ root
		ifNil: [ root := (ArtLeafNode on: self)
				key: key;
				value: aValue;
				parent: self;
				yourself.
			tally := tally + 1.
			aValue ]
		ifNotNil: [ root at: key put: aValue depth: 1 ]
]

{ #category : #removing }
ArtTree >> fixCollisionsFrom: start [

]

{ #category : #enumerating }
ArtTree >> flatCollect: aBlock [ 
	^ self flatCollect: aBlock as: OrderedCollection
]

{ #category : #testing }
ArtTree >> includesKey: key [
	^ (self at: key) ifNil: [ false ] ifNotNil: [ true ]
]

{ #category : #initialization }
ArtTree >> initialize [
	super initialize.
	tally := 0
]

{ #category : #'rectangle functions' }
ArtTree >> intersection: aCollection [
	| other result duplicates |

	other := aCollection asSet.
	duplicates := Set new.
	result := self class new: self size.

	self
		keysAndValuesDo: [ :key :value | 
			((other includes: value) and: [ (duplicates includes: value) not ])
				ifTrue: [ duplicates add: value.
					result at: key put: value ] ].

	^ result
]

{ #category : #testing }
ArtTree >> isDictionary [
	^ false
]

{ #category : #testing }
ArtTree >> isHealthy [
	^ true
]

{ #category : #'private-accessing' }
ArtTree >> nodeAt: aKey [
	^ root
		ifNotNil: [ :node | node nodeAt: aKey asByteArray ensureNullTerminated depth: 1 ]
]

{ #category : #removing }
ArtTree >> remove: oldObject ifAbsent: anExceptionBlock [
	(oldObject respondsTo: #asByteArray)
		ifFalse: [ ^ self errorImproperStore ].

	^ self removeKey: oldObject asByteArray ifAbsent: anExceptionBlock
]

{ #category : #removing }
ArtTree >> removeAll [
	self initializeWithRoot: nil
]

{ #category : #removing }
ArtTree >> removeKey: aKey [
	^ self removeKey: aKey ifAbsent: [ self errorKeyNotFound: aKey ]
]

{ #category : #removing }
ArtTree >> removeKey: aKey ifAbsent: absentBlock [
	"Remove and answer value associated with given key. If key is not found, answer result of evaluating absentBlock."

	| k |

	k := aKey asByteArray ensureNullTerminated.
	^ root
		ifNil: [ absentBlock value ]
		ifNotNil: [ (root isLeaf and: [ root matchesKey: aKey ])
				ifTrue: [ | val |

					val := root.
					root := nil.
					self tallyDown: 1.
					val ]
				ifFalse: [ root removeKey: k ifAbsent: absentBlock depth: 1 ] ]
]

{ #category : #private }
ArtTree >> replaceChild: aChild with: aNewChild [
	aNewChild parent: self.
	root := aNewChild
]

{ #category : #accessing }
ArtTree >> root [
	^ root
]

{ #category : #'state tracking' }
ArtTree >> tallyDown: aCount [
	tally := tally - aCount
]

{ #category : #'state tracking' }
ArtTree >> tallyUp: aCount [
	tally := tally + aCount
]

{ #category : #enumerating }
ArtTree >> valuesDo: aBlock [ 
	root ifNil: [ ^ self ].
	root valuesDo: aBlock
]
