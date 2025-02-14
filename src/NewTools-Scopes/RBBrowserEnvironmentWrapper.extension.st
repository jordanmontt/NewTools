Extension { #name : 'RBBrowserEnvironmentWrapper' }

{ #category : '*NewTools-Scopes' }
RBBrowserEnvironmentWrapper >> asScopeNode [

	self subclassResponsibility
]

{ #category : '*NewTools-Scopes' }
RBBrowserEnvironmentWrapper >> isNotEmpty [
	^ self isEmpty not
]

{ #category : '*NewTools-Scopes' }
RBBrowserEnvironmentWrapper >> packagesDo: aBlock [

	self packages do: [ :each | aBlock value: each ]
]

{ #category : '*NewTools-Scopes' }
RBBrowserEnvironmentWrapper >> systemScope [
	^ self
]
