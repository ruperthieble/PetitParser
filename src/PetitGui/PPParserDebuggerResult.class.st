"
This class is meant to be used as a model for running a parser over a given stream.

You create it via parse:with: class side method. For example:
self parse: '1 + 2' with: PPArithmeticParser new.

Instance Variables:
	parser	<PPParser>
	result	<Object>
	children	<OrderedCollection of PPParserDebuggerResult>
	parent	<PPParserDebuggerResult>
"
Class {
	#name : #PPParserDebuggerResult,
	#superclass : #Object,
	#instVars : [
		'parser',
		'result',
		'children',
		'parent',
		'start',
		'end'
	],
	#category : #'PetitGui-Core'
}

{ #category : #'instance creation' }
PPParserDebuggerResult class >> parse: aStream with: parser [ 
	| root newParser |
	root := self new.
	newParser := parser transform: [:each |
		each name isNil 
			ifTrue: [ each ]
			ifFalse: [
				each >=> [:stream :continuation | 
					| result child |
					child := PPParserDebuggerResult new 
							parser: each;
							parent: root.
					root := root children add: child.
					child start: stream position + 1.
					result := continuation value.
					child end: stream position.
					root result: result.
					root := root parent.
					result ]]].
	newParser parse: aStream.
	^ root children first
]

{ #category : #accessing }
PPParserDebuggerResult >> children [
	^ children
]

{ #category : #accessing }
PPParserDebuggerResult >> children: anObject [
	children := anObject
]

{ #category : #accessing }
PPParserDebuggerResult >> end [
	^ end
]

{ #category : #accessing }
PPParserDebuggerResult >> end: anObject [
	end := anObject
]

{ #category : #printing }
PPParserDebuggerResult >> formattedText [
	^ self result isPetitFailure 
		ifTrue: [ Text string: self printString attribute: TextColor gray ]
		ifFalse: [ self printString]
]

{ #category : #initialization }
PPParserDebuggerResult >> initialize [ 
	children := OrderedCollection new
]

{ #category : #accessing }
PPParserDebuggerResult >> parent [
	^ parent
]

{ #category : #accessing }
PPParserDebuggerResult >> parent: anObject [
	parent := anObject
]

{ #category : #accessing }
PPParserDebuggerResult >> parser [
	^ parser
]

{ #category : #accessing }
PPParserDebuggerResult >> parser: anObject [
	parser := anObject
]

{ #category : #printing }
PPParserDebuggerResult >> printOn: aStream [ 
	aStream 
		nextPutAll: self parser displayName;
		nextPutAll: ' - ';   
		nextPutAll: self result printString
]

{ #category : #accessing }
PPParserDebuggerResult >> result [
	^ result
]

{ #category : #accessing }
PPParserDebuggerResult >> result: anObject [
	result := anObject
]

{ #category : #accessing }
PPParserDebuggerResult >> start [
	^ start
]

{ #category : #accessing }
PPParserDebuggerResult >> start: anObject [
	start := anObject
]