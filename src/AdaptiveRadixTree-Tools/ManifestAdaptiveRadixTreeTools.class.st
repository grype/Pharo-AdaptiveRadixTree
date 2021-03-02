"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestAdaptiveRadixTreeTools,
	#superclass : #PackageManifest,
	#category : #'AdaptiveRadixTree-Tools-Manifest'
}

{ #category : #'code-critics' }
ManifestAdaptiveRadixTreeTools class >> ruleThreeElementPointRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#ArtNodeVisualizer #buildWithNode: #false)) #'2021-02-02T23:03:19.324257-08:00') )
]
