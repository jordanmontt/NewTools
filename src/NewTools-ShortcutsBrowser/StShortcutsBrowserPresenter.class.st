"
I am a shortcut browser that allows to see the available Pharo's shortcuts 
"
Class {
	#name : 'StShortcutsBrowserPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'actionBar',
		'categoryList',
		'shortcutTable',
		'inputPresenter'
	],
	#category : 'NewTools-ShortcutsBrowser',
	#package : 'NewTools-ShortcutsBrowser'
}

{ #category : 'accessing' }
StShortcutsBrowserPresenter class >> defaultPreferredExtent [

	^ 900 @ 650
]

{ #category : 'instance creation' }
StShortcutsBrowserPresenter class >> descriptionText [

	^ 'Show the system''s shortcuts'
]

{ #category : 'accessing' }
StShortcutsBrowserPresenter class >> icon [

	^ self iconNamed: #keymapBrowser
]

{ #category : 'instance creation' }
StShortcutsBrowserPresenter class >> menuCommandOn: aBuilder [
	<worldMenu>

	(aBuilder item: 'Shortcuts Browser')
		action: [ self open ];
		order: 34;
		parent: #Tools;
		icon: self icon;
		help: self descriptionText
]

{ #category : 'instance creation' }
StShortcutsBrowserPresenter class >> open [

	<script>
	^ (self newApplication: StPharoApplication current) open
]

{ #category : 'initialization' }
StShortcutsBrowserPresenter >> allAPIsEntry [
	"Set the receiver's category items to a list of categories in aCollectionOfSymbols.
	We also build an 'All' category including all keymaps in aCollectionOfSymbols"

	| newCategoryItem |
	newCategoryItem := StKMCategory new categoryName: 'All'.
	KMRepository default categories inject: newCategoryItem into: [ :a :b | a , b ].
	newCategoryItem addAllShortcuts: self shortcutActivationCmdInstances.
	^ newCategoryItem
]

{ #category : 'callbacks' }
StShortcutsBrowserPresenter >> browseKeyMapMethod: aKMKeyMap [

	self application tools browser openOnMethod: aKMKeyMap action method
]

{ #category : 'initialization' }
StShortcutsBrowserPresenter >> connectPresenters [

	categoryList transmitTo: shortcutTable transform: [ :item | self keymapsAtCategory: item model ].
	inputPresenter whenTextChangedDo: [ :text | self filterTable: text ].
	shortcutTable whenActivatedDo: [ :item | self inspectKeyMap: item selectedItem ]
]

{ #category : 'layout' }
StShortcutsBrowserPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 6;
		  add: (SpBoxLayout newLeftToRight
				   add: 'Filter scopes' expand: false;
				   add: categoryList;
				   yourself)
		  expand: false;
		  add: inputPresenter expand: false;
		  add: shortcutTable;
		  add: actionBar withConstraints: [ :c | c height: 25 ];
		  yourself
]

{ #category : 'callbacks' }
StShortcutsBrowserPresenter >> filterTable: aText [

	| newItems |
	aText ifEmpty: [
		shortcutTable items: (self keymapsAtCategory: categoryList selectedItem).
		^ self ].

	newItems := (self keymapsAtCategory: categoryList selectedItem) select: [ :each |
		            { each name. each scopeName. each description } anySatisfy: [ :aString | 
								aString includesSubstring: aText caseSensitive: false ] ].
	shortcutTable items: newItems
]

{ #category : 'initialization' }
StShortcutsBrowserPresenter >> initialize [

	| shortcutCategories |
	super initialize.

	shortcutCategories := { self allAPIsEntry } , self shortcutActivationCategoriesItems
	                      , (KMRepository default categories keys collect: [ :e | KMRepository default categoryForName: e ]).
	categoryList items: shortcutCategories
]

{ #category : 'initialization' }
StShortcutsBrowserPresenter >> initializePresenters [

	categoryList := self newDropList
		                display: [ :category | category name ];
		                yourself.
	inputPresenter := self newTextInput
		                  placeholder: 'Filter';
		                  yourself.

	shortcutTable := self newTable.
	shortcutTable
		activateOnDoubleClick;
		addColumn: (SpStringTableColumn new
				 title: 'Name';
				 evaluated: #name;
				 beSortable;
				 yourself);
		addColumn: (SpStringTableColumn title: 'Shortcut' evaluated: #shortcut);
		addColumn: (SpStringTableColumn title: 'Description' evaluated: #description);
		addColumn: (SpStringTableColumn new
				 title: 'Scope';
				 evaluated: [ :each | each scopeName ];
				 beSortable;
				 width: 150;
				 yourself);
		beResizable.

	actionBar := self newActionBar.
	actionBar
		addLast: (SpButtonPresenter new
				 action: [ self browseKeyMapMethod: shortcutTable selectedItem  ];
				 label: 'Browse';
				 yourself);
		addLast: (SpButtonPresenter new
				 action: [ self inspectKeyMap: shortcutTable selectedItem ];
				 label: 'Inspect';
				 yourself)
]

{ #category : 'callbacks' }
StShortcutsBrowserPresenter >> inspectKeyMap: aKMKeyMap [

	self application tools inspector openOn: aKMKeyMap
]

{ #category : 'callbacks' }
StShortcutsBrowserPresenter >> keymapsAtCategory: aKMCategoryOrKMCategoryAll [
	"Answer a <Collection> of keymaps"
	^ aKMCategoryOrKMCategoryAll keymaps
]

{ #category : 'initialization' }
StShortcutsBrowserPresenter >> shortcutActivationCategoriesItems [
	"Answer a <Collection> of <KMCategoryItemPresenter> representing each a category of keymaps created using the Commander 1 framework"
	
	| shortcutActivationCategories |
	shortcutActivationCategories := (self shortcutActivationCmdInstances groupedBy: [ :cmdShortcutActivation |
		                                 cmdShortcutActivation annotatedClass packageName ]) values.

	^ shortcutActivationCategories collect: [ :keymaps |
		  StKMCategory new
			  categoryName: keymaps anyOne annotatedClass packageName;
			  keymaps: keymaps;
			  yourself ]
]

{ #category : 'initialization' }
StShortcutsBrowserPresenter >> shortcutActivationCmdInstances [

	^ CmdShortcutActivation registeredInstances copyWithoutAll: CmdShortcutActivation redefiningInstances
]

{ #category : 'accessing' }
StShortcutsBrowserPresenter >> windowTitle [

	^ 'Shortcuts Browser'
]
