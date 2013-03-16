Class {
	#name : #PPAbstractParserTest,
	#superclass : #TestCase,
	#category : #'PetitTests-Core'
}

{ #category : #testing }
PPAbstractParserTest class >> isAbstract [
	^ self name = #PPAbstractParserTest
]

{ #category : #accessing }
PPAbstractParserTest class >> packageNamesUnderTest [
	^ #('PetitParser' 'PetitTests')
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser fail: aCollection [
	^ self assert: aParser fail: aCollection end: 0
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser fail: aCollection end: anInteger [
	| stream result |
	self 
		assert: aParser isPetitParser
		description: 'Parser invalid'.
	stream := aCollection asPetitStream.
	result := aParser parse: stream.
	self 
		assert: result isPetitFailure
		description: 'Parser did not fail'.
	self
		assert: stream position = anInteger
		description: 'Parser failed at wrong position'.
	^ result
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aCollection [
	^ self assert: aParser parse: aCollection to: nil end: aCollection size 
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aCollection end: anInteger [
	^ self assert: aParser parse: aCollection to: nil end: anInteger
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aCollection to: anObject [
	^ self assert: aParser parse: aCollection to: anObject end: aCollection size 
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aCollection to: aTargetObject end: anInteger [
	| stream result |
	self 
		assert: aParser isPetitParser
		description: 'Parser invalid'.
	stream := aCollection asPetitStream.
	result := aParser parse: stream.
	aTargetObject isNil
		ifTrue: [ self deny: result isPetitFailure ]
		ifFalse: [ self assert: result = aTargetObject ].
	self 
		assert: stream position = anInteger
		description: 'Parser accepted at wrong position'.
	^ result
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aCollection toToken: aStartInteger stop: aStopInteger [
	^ self assert: aParser parse: aCollection toToken: aStartInteger stop: aStopInteger end: aCollection size
]

{ #category : #utilities }
PPAbstractParserTest >> assert: aParser parse: aParserObject toToken: aStartInteger stop: aStopInteger end: anEndInteger [
	| token |
	token := self assert: aParser parse: aParserObject to: nil end: anEndInteger.
	self assert: (token isKindOf: PPToken).
	self assert: (token start = aStartInteger).
	self assert: (token stop = aStopInteger).
	^ token
]