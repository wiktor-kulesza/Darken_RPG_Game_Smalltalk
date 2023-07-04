
"Collaborators:
* Wiktor Kulesza
* Filip Wiśniewski
* Jakub Tomaszewski"

"PARP 22Z"


Object subclass: Game [
    | isGameOver player dragon princess|

    cantGoText := #('There is no path in that direction').

    instructionsText := #(
        'Available commands are:'
        ''
        'instructions       -- to see these instructions.'
        'n  s   e   w       -- to go in that direction.'
        'quit               -- to end the game and quit.'
        'take "object"      -- to pick up an object.'
        'attack "hero"      -- to attack an object.'
        'search "object"    -- to try to search an object'
        'drop "object"      -- to put down an object.'
        'look               -- to look around you again.'
        'i                  -- to list your inventory.'
        ''
    ).

    Game class >> new [
        <category: 'instance creation'>
        | g |
        g := super new.
        g init.
        ^g
    ]

    init [
        isGameOver := false.
        "initializing player"
        player := Player new.
        dragon := CharacterInGame new.
        dragon newName: 'dragon'.
        princess := CharacterInGame new.
        princess newName: 'princess'.
    ]

    getPrincess [^princess.]

    getDragon [^dragon.]

    getPlayer [^player.]


    "Print strings from array in separate lines."
    printLines: anArray [
        anArray do: [ :string | Transcript show: string; cr ]
    ]

    printAll [
        Transcript cr; cr.
        self printLocation.
        Transcript cr.
        self printPossibleLocations.
    ]

    printInstructions [self printLines: instructionsText.]

    printItems [
        |locationItems|
        locationItems := self getPlayer getLocation getItems.
        (locationItems isNil) | (locationItems size = 0)  ifFalse: [
            Transcript show: 'You can see those objects in the room:'; cr.
            self getPlayer getLocation printItems.
        ]
        ifTrue: [
            Transcript show: 'There are no objects in the room.'; cr.
        ].
    ]

    printCharacters [
        |locationCharacters|
        locationCharacters := self getPlayer getLocation getCharacters.
        (locationCharacters isNil) | (locationCharacters size = 0)  ifFalse: [
            Transcript show: 'You can see those characters in the room:'; cr.
            self getPlayer getLocation printCharacters.
        ]
        ifTrue: [
            Transcript show: 'There are no characters in the room.'; cr.
        ].
    ]

    printLocation [
        Transcript show: 'You are at '; show: self getPlayer getLocation getName; cr.
        (self getPlayer getLocation getDescription isNil) ifFalse: [
            Transcript show: self getPlayer getLocation getDescription; cr.
        ].
        self printItems.
        self printCharacters.
    ]

    noArgumentHandle [
        Transcript show: 'No argument passed so cant handle action.'; cr.
    ]

    printPossibleLocations [
        Transcript show: 'You can go to: '; cr.
        (self getPlayer getLocation getN isNil) ifFalse: [
                Transcript show: 'N - '; show: self getPlayer getLocation getN getName; cr.
            ].
        (self getPlayer getLocation getE isNil) ifFalse: [
                Transcript show: 'E - '; show: self getPlayer getLocation getE getName; cr.
            ].
        (self getPlayer getLocation getS isNil) ifFalse: [
                Transcript show: 'S - '; show: self getPlayer getLocation getS getName; cr.
            ].
        (self getPlayer getLocation getW isNil) ifFalse: [
                Transcript show: 'W - '; show: self getPlayer getLocation getW getName; cr.
            ].
    ]

    readCommand [
        Transcript show: '> '.
        ^ FileStream stdin nextLine substrings.
    ]

    checkIfContiniue [
        self getPrincess getIsAlive & self getDragon getIsAlive ifTrue: [
            ^true.
        ] ifFalse: [
            ^false.
        ]
    ]

    checkWin [
        ^ self getDragon getIsAlive = false.
    ]

    checkLose [
        ^ self getPrincess getIsAlive = false.
    ]

    "Run the game."
    run [
        | cmd isUnknown command arg tmp tmp2|
        
        self printInstructions.
        self printLocation.
        self printPossibleLocations.
        " self printPossibleLocations. "

        "Game loop."
        [isGameOver] whileFalse: [
            self checkIfContiniue ifFalse: [
                self checkLose ifTrue: [
                    Transcript show: 'You monster, you killed a princess! ROT IN HELL!!!'; cr.
                    isGameOver := true.
                    ^false.
                ].
                self checkWin ifTrue: [
                    Transcript show: 'Congratulations you killed a dragon and saved a princess!'; cr.
                    isGameOver := true.
                    ^true.
                ].
            ].
            isUnknown := true.
            cmd := self readCommand.
            command := nil.
            cmd size > 0 ifTrue: [
                command := cmd at: 1.
            ].
            arg := nil.
            cmd size > 1 ifTrue: [
                arg := cmd at: 2.
            ].
            

            command = 'instructions' ifTrue: [
                self printInstructions.
                isUnknown := false
            ].

            command = 'quit' ifTrue: [
                isGameOver := true.
                isUnknown := false
            ].

            command = 'n' ifTrue: [
                (self getPlayer getLocation ~= nil) & (self getPlayer getLocation getN ~= nil) 
                ifTrue: [
                    tmp := self getPlayer getLocation getN.
                    (self getPlayer goTo: tmp) ifTrue: [
                        self printAll.
                    ].
                ]
                ifFalse: [
                    Transcript show: cantGoText printString.
                    Transcript cr.
                ].
                isUnknown := false.
            ].

            command = 'e' ifTrue: [
                (self getPlayer getLocation ~= nil) & (self getPlayer getLocation getE ~= nil) 
                ifTrue: [
                    tmp := self getPlayer getLocation getE.
                    (self getPlayer goTo: tmp) ifTrue: [
                        self printAll.
                    ].
                ]
                ifFalse: [
                    Transcript show: cantGoText printString.
                    Transcript cr.
                ].
                isUnknown := false.
            ].

            command = 's' ifTrue: [
                (self getPlayer getLocation ~= nil) & (self getPlayer getLocation getS ~= nil) 
                ifTrue: [
                    tmp := self getPlayer getLocation getS.
                    (self getPlayer goTo: tmp) ifTrue: [
                        self printAll.
                    ].
                ]
                ifFalse: [
                    Transcript show: cantGoText printString.
                    Transcript cr.
                ].
                isUnknown := false.
            ].

            command = 'w' ifTrue: [
                (self getPlayer getLocation ~= nil) & (self getPlayer getLocation getW ~= nil) 
                ifTrue: [
                    tmp := self getPlayer getLocation getW.
                    (self getPlayer goTo: tmp) ifTrue: [
                        self printAll.
                    ].
                ]
                ifFalse: [
                    Transcript show: cantGoText printString.
                    Transcript cr.
                ].
                isUnknown := false.
            ].

            command = 'i' ifTrue: [
                Transcript show: 'You have:'; cr.
                self getPlayer printInventory.
                isUnknown := false.
            ].

            command = 'take' ifTrue: [
                (arg ~= nil) ifTrue: [
                    tmp := self getPlayer getLocation getItem: arg.
                    (tmp = nil)
                    ifFalse: [
                        self getPlayer getLocation removeItem: tmp.
                        self getPlayer addItem: tmp.
                        Transcript show: 'Successfully added '; show: tmp getName; show: ' to equipment'; cr.
                    ]
                    ifTrue: [
                        Transcript show: 'Cant pick '; show: arg; cr.
                        Transcript show: 'Maybe item isnt here, cant be taken or you need to open some other item to find it inside.'; cr.
                    ].
                ]
                ifFalse: [
                    self noArgumentHandle.
                ]. 
                isUnknown := false.
            ].
            command = 'search' ifTrue: [
                |canOpen|
                canOpen := true.
                (arg ~= nil) ifTrue: [
                    tmp := self getPlayer getLocation getSearchableItem: arg.
                    (tmp = nil)
                    ifFalse: [
                        tmp2 := self getPlayer getInventory asSet.
                        tmp getWhatOpens do: [ 

                            :a| (tmp2 includes: a) ifFalse: [
                                Transcript show: 'You dont have items needed to open '; show: tmp getName; cr.
                                canOpen := false.
                            ]
                        ].
                        canOpen ifTrue: [
                            tmp newIsOpened: true.
                            Transcript show: 'You opened '; show: tmp getName; show: ' and found those items inside:'; cr.
                            tmp getItems do: [
                                :a| Transcript show: '- '; show: a getName; cr.
                        ].
                        ]
                    ] ifTrue: [
                        Transcript show: 'There is no such an object or you cant search it.'
                    ]

                ]
                ifFalse: [
                    self noArgumentHandle.
                ].
                isUnknown := false.   
            ].

            command = 'drop' ifTrue: [
                (arg ~= nil) ifTrue: [
                    tmp := false.
                    self getPlayer getInventory do: [
                        :a| (a getName = arg) ifTrue: [
                            self getPlayer getLocation getItems add: a.
                            self getPlayer getInventory remove: a.
                            Transcript show: 'You droped: '; show: a getName; cr.
                            tmp := true
                        ]
                    ].
                    tmp ifFalse: [
                        Transcript show: 'You dont have '; show: arg; show: ' in your equipment'; cr.
                    ]
                ]
                ifFalse: [
                    self noArgumentHandle.
                ].
                isUnknown := false.
            ].

            command = 'look' ifTrue: [
                self printLocation.
                self printPossibleLocations.
                isUnknown := false.
            ].

            command = 'attack' ifTrue: [
                |didKill wasCharacter|
                wasCharacter := false.
                didKill := false.
                (arg ~= nil) ifTrue: [
                    self getPlayer getLocation getCharacters do: [
                        :a| (a getName = arg) ifTrue: [
                            wasCharacter := true.
                            self getPlayer getInventory do: [
                                :b| b getName = 'sword' ifTrue: [
                                    a newIsAlive: false.
                                    Transcript show: 'You killed '; show: a getName; cr.
                                    didKill := true.
                                ]
                            ].
                            (didKill) ifFalse: [
                                Transcript show: 'You cant attack without a weapon'; cr. 
                            ]
                        ].
                    ].
                    (wasCharacter) ifFalse: [
                        Transcript show: 'There is no '; show: arg; show: ' here'; cr.
                    ]
                ]
                ifFalse: [
                    self noArgumentHandle.
                ].
                isUnknown := false.
            ].
                
            isUnknown ifTrue: [
                self printLines: #('Unknown command.' '')
            ]
        ]
    ]
]

game := Game new.

"Initializing locations"
cellar := Location new newName: 'cellar'.
stairs := Location new newName: 'stairs'.
armory := Location new newName: 'armory'.
armory_room_hint := 'Those doors are quite heavy and seem to have realy complicated lock. Perhaps I have to look for some kind of key'.

armory newHint: armory_room_hint.
grand_hall := Location new newName: 'grand_hall'.
dinning_hall := Location new newName: 'dinning_hall'.
kitchen := Location new newName: 'kitchen'.
barracks := Location new newName: 'barracks'.
throne_room := Location new newName: 'throne_room'.
throne_room_hint := 'Those doors are so huge and seem to have realy complicated lock. It looks like there are 3 holes here, hmmm...Perhaps I have to look for some kind of key or even few of them...'.

throne_room newHint: throne_room_hint.
tower_stairs := Location new newName: 'tower_stairs'.
observatory := Location new newName: 'observatory'.
basement := Location new newName: 'basement'.


"Initializing items"
key := Item new newIsOpenable: false; newName: 'key'.

pick := Item new newIsOpenable: false; newName: 'pick'.

ironChest := Item new newIsOpenable: true; newIsOpened: false; newCanTake: false.

woodenChest := Item new newIsOpenable: true; newIsOpened: false; newCanTake: false.

wardrobe := Item new newIsOpenable: true; newIsOpened: true; newCanTake: false.

desk := Item new newIsOpenable: true; newIsOpened: true; newCanTake: false.

sword := Item new newIsOpenable: false; newName: 'sword'.

torch1 := Item new newIsOpenable: false; newName: 'torch1'.

torch2 := Item new newIsOpenable: false; newName: 'torch2'.

keyFragment1 := Item new newIsOpenable: false; newName: 'keyFragment1'.

keyFragment2 := Item new newIsOpenable: false; newName: 'keyFragment2'.

keyFragment3 := Item new newIsOpenable: false; newName: 'keyFragment3'.

pile_of_bones := Item new newIsOpenable: false; newName: 'pileOfBones'; newCanTake: false.

corpses := Item new newIsOpenable: false; newName: 'corpses'; newCanTake: false.

opensIronChest := OrderedCollection new.
opensIronChest add: pick.
itemsIronChest := OrderedCollection new. 
itemsIronChest add: keyFragment3.
ironChest newWhatOpens: opensIronChest.
ironChest newItems: itemsIronChest; newName: 'ironChest'.

opensWoodenChest := OrderedCollection new.
opensWoodenChest add: pick.
itemsWoodenChest := OrderedCollection new.
itemsWoodenChest add: keyFragment1.
woodenChest newWhatOpens: opensWoodenChest;  newItems: itemsWoodenChest; newName: 'woodenChest'.

itemsWardrobe := OrderedCollection new.
itemsWardrobe add: pick.
wardrobe newItems: itemsWardrobe; newName: 'wardrobe'.


itemsDesk := OrderedCollection new.
itemsDesk add: key; add: keyFragment2.
desk newItems: itemsDesk; newName: 'desk'.


cellar newS: armory.
cellar newN: stairs.
cellar newIsOpened: true.

itemsArmory := OrderedCollection new.
itemsArmory add: sword.
opensArmory := OrderedCollection new.
opensArmory add: key.
armory newN: cellar; newItems: itemsArmory; newWhatOpens: opensArmory; newIsOpened: false.

itemsStairs := OrderedCollection new.
itemsStairs add: torch1.
stairs newS: cellar.
stairs newN: grand_hall.
stairs newItems: itemsStairs; newIsOpened: true.

itemsGrandHall := OrderedCollection new.
itemsGrandHall add: wardrobe.
grand_hall newN: throne_room.
grand_hall newE: barracks.
grand_hall newS: stairs.
grand_hall newW: dinning_hall.
grand_hall newItems: itemsGrandHall; newIsOpened: true.

charactersThroneRoom := OrderedCollection new.
charactersThroneRoom add: game getPrincess; add: game getDragon.
opensThroneRoom := OrderedCollection new.
opensThroneRoom add: keyFragment1; add: keyFragment2; add: keyFragment3.
throne_room newS: grand_hall.
throne_room newIsOpened: false; newCharacters: charactersThroneRoom. 
throne_room newWhatOpens: opensThroneRoom.

itemsBarracks := OrderedCollection new.
itemsBarracks add: woodenChest.
barracks newW: grand_hall.
barracks newIsOpened: true; newItems: itemsBarracks.

itemsDinningHall := OrderedCollection new.
itemsDinningHall add: pile_of_bones; add: corpses.
dinning_hall newN: kitchen.
dinning_hall newE: grand_hall.
dinning_hall newW: tower_stairs.
dinning_hall newIsOpened: true; newItems: itemsDinningHall.

itemsKitchen := OrderedCollection new.
itemsKitchen add: ironChest.
kitchen newS: dinning_hall.
kitchen newIsOpened: true; newItems: itemsKitchen.

itemsTowerStairs := OrderedCollection new.
itemsTowerStairs add: torch2.
tower_stairs newE: dinning_hall.
tower_stairs newS: observatory.
tower_stairs newIsOpened: true; newItems: itemsTowerStairs.

itemsObservatory := OrderedCollection new.
itemsObservatory add: desk.
observatory newN: tower_stairs.
observatory newIsOpened: true; newItems: itemsObservatory.





"initializing player's location"
game getPlayer newLocation: cellar.
game run.
