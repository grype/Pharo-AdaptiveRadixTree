Class {
	#name : #ArtNode,
	#superclass : #Object,
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #accessing }
ArtNode class >> leafWithKey: aKey value: aValue [
	^ ArtLeafNode key: aKey value: aValue
]

{ #category : #'instance creation' }
ArtNode class >> node16 [
	^ ArtNode16 new
]

{ #category : #'instance creation' }
ArtNode class >> node256 [
	^ ArtNode256 new
]

{ #category : #'instance creation' }
ArtNode class >> node4 [
	^ ArtNode4 new
]

{ #category : #'instance creation' }
ArtNode class >> node48 [
	^ ArtNode48 new
]

{ #category : #accessing }
ArtNode >> at: aKey put: aValue depth: depth [
	"Insert aValue at aKey, starting with given depth. This method is meant to be called recursively.
	 Returns true if a node was actually added (as opposed to updating existing node)."
	^ self subclassResponsibility 
]

{ #category : #testing }
ArtNode >> isLeaf [
	^ false
]

{ #category : #accessing }
ArtNode >> maximum [
	"Returns the right-most leaf node by recursively traversing children using highest byte index"
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> minimum [
	"Returns the left-most leaf node by recursively traversing children using lowest byte index"
	^ self subclassResponsibility 
]

{ #category : #removing }
ArtNode >> removeKey: aKey ifAbsent: absentBlock depth: depth [
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> search: aKey depth: anObject [
	^ self subclassResponsibility 
]

{ #category : #accessing }
ArtNode >> size [
	"Returns number of children"
	^ self subclassResponsibility 
]
