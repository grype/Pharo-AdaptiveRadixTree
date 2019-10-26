Class {
	#name : #ArtLeafNode,
	#superclass : #ArtNode,
	#instVars : [
		'key',
		'value'
	],
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #accessing }
ArtLeafNode class >> key: aKey value: aValue [
	^ self basicNew initializeWithKey: aKey value: aValue
]

{ #category : #comparing }
ArtLeafNode >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ value = anObject value and: [ key = anObject key ]
]

{ #category : #accessing }
ArtLeafNode >> at: aKey depth: depth [
	^ (self matchesKey: aKey)
		ifTrue: [ value ]
		ifFalse: [ nil ]
]

{ #category : #accessing }
ArtLeafNode >> at: aKey put: aValue depth: depth [
	"Insert aValue at aKey, starting with given depth. This method is meant to be called recursively and is expected to return the inserted value"

	| newLeaf newContainer lcp |

	(self matchesKey: aKey)
		ifTrue: [ self value: aValue.
			^ false ].

	newLeaf := ArtNode leafWithKey: aKey value: aValue.
	newContainer := ArtNode node4.
	lcp := key longestCommonPrefixWith: aKey startingAt: depth.
	newContainer
		prefix:
			(aKey
				copyFrom: depth
				to: ((depth + lcp - 1) min: ArtContainerNode maxPrefixSize));
		prefixSize: lcp.

	self become: newContainer.
	self addChild: newContainer at: (newContainer key at: depth + lcp).
	self addChild: newLeaf at: (newLeaf key at: depth + lcp).

	ArtCurrentTree value ifNotNil: [ :tree | tree addedChildren: 1 ].
	^ aValue
]

{ #category : #comparing }
ArtLeafNode >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ value hash bitXor: key hash
]

{ #category : #initialization }
ArtLeafNode >> initializeWithKey: aKey value: aValue [
	self initialize.
	key := aKey asByteArray copy.
	value := aValue
]

{ #category : #testing }
ArtLeafNode >> isLeaf [
	^ true
]

{ #category : #accessing }
ArtLeafNode >> key [
	^ key
]

{ #category : #testing }
ArtLeafNode >> matchesKey: aKey [
	^ aKey isNotNil and: [ aKey asByteArray = key ]
]

{ #category : #accessing }
ArtLeafNode >> maximum [
	^ self
]

{ #category : #accessing }
ArtLeafNode >> minimum [
	"Returns the left-most leaf node by recursively traversing children using lowest byte index"
	^ self
]

{ #category : #printing }
ArtLeafNode >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' key: ';
		print: key
]

{ #category : #removing }
ArtLeafNode >> removeKey: aKey ifAbsent: absentBlock depth: depth [
	^ self shouldNotImplement 
]

{ #category : #accessing }
ArtLeafNode >> size [
	^ 0
]

{ #category : #accessing }
ArtLeafNode >> value [
	^ value
]

{ #category : #accessing }
ArtLeafNode >> value: anObject [
	value := anObject
]
