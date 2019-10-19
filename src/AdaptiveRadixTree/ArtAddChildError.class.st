Class {
	#name : #ArtAddChildError,
	#superclass : #Error,
	#instVars : [
		'node'
	],
	#category : #'AdaptiveRadixTree-Core'
}

{ #category : #signalling }
ArtAddChildError class >> signal: aMessage node: aNode [
	^ self new
		node: aNode;
		signal: aMessage
]

{ #category : #accessing }
ArtAddChildError >> node [
	^ node
]

{ #category : #accessing }
ArtAddChildError >> node: anObject [
	node := anObject
]
