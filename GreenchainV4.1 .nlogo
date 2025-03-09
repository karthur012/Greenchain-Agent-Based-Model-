extensions [table]

;; Variable Declarations

globals [

  ; Token metrics
  gch-price           ; Current GCH token price
  gch-supply          ; Total GCH supply
  yearly-emission-rate    ; Rate at which new GCH tokens are created yearly
  last-emission-tick      ; Track last emission time
  total-gch-staked    ; Amount of staked GCH
  green-spaces        ; Table of green space properties
  gsst-prices         ; Table of GSST prices
  revenue-pools       ; Table of revenue pools for each space

  ; Market metrics
  total-volume        ; Trading volume
  market-sentiment    ; Market sentiment multiplier
  bid-list            ; List of buy orders
  ask-list            ; List of sell orders

  ; Performance tracking
  price-history       ; Historical GCH prices
  volume-history      ; Historical trading volumes
  staking-history     ; Historical staking amounts
  revenue-history     ; Historical revenues
  user-base           ; Number of active token holders
  nft-metrics-history ; Historical NFT metrics

  trade-radius        ; Radius within which agents can trade
  nft-trade-radius    ; Radius for NFT trading (may differ from token trading)
  movement-speed      ; Speed of agent movement
  trade-spots         ; Agentset of patches where trading occurs
  current-traders     ; List of agents currently trading

  total-consumer-nfts    ; Total NFTs held by consumers
  total-investor-nfts    ; Total NFTs held by investors
  avg-developer-rating   ; Average reputation rating of developers
  total-nfts             ; Sum of all NFTs in the system

  ; NFT System variables
  nft-marketplace     ; Table for NFT marketplace
  nft-prices          ; Table of NFT prices
  nft-trading-fee     ; Fee applied to NFT transactions
  reputation-tiers    ; Reputation tiers for vendors
  nft-transaction-history ; History of NFT transactions
  nft-trade-volume    ; Volume of NFT trades
  dao-governance      ; Table of governance voting power
  total-dao-votes     ; Total governance votes
  nft-fund-allocation ; Funds allocated to green spaces from NFT fees


]


;; Breed Definitions

breed [investors investor]
breed [developers developer]
breed [consumers consumer]

investors-own [
  gch-holdings        ; Amount of GCH tokens held
  gsst-holdings       ; Table of GSST holdings
  staked-amount       ; Amount of GCH staked
  staking-period      ; Duration of staking
  total-benefits      ; Accumulated benefits
  social-preference   ; Weight for social impact
  trading-cooldown    ; Trading delay counter
  activeness          ; Probability of trading
  wealth              ; Total value in GCH terms
  bid-price           ; Current bid price
  ask-price           ; Current ask price
  bid-amount          ; Current bid amount
  ask-amount          ; Current ask amount
  owned-nfts          ; Table of owned NFTs
  dao-voting-power    ; Power in governance decisions
]

developers-own [
  green-space-id      ; ID of owned green space
  gsst-supply         ; Supply of space-specific tokens
  customer-base       ; Number of customers
  land-value          ; Current land value
  revenue             ; Accumulated revenue
  maintenance-cost    ; Operating costs
  quality-score       ; Green space quality metric
  development-stage   ; Current development phase
  reputation-nft      ; Reputation NFT level (1-5 stars)
  issued-nfts         ; Table of NFTs issued by this developer
  sustainability-rating ; Rating based on eco-friendly practices
]

consumers-own [
  spending-capacity   ; How much a consumer can spend
  preferred-spaces    ; List of preferred green spaces
  gsst-holdings       ; Table of GSST holdings
  discount-nfts       ; Discount NFTs owned
  access-nfts         ; Access NFTs owned
  reputation-nfts     ; Reputation NFTs earned
  event-nfts          ; Event-based NFTs collected
  governance-nfts     ; Governance NFTs owned
  event-participation ; Participation in events
  vendor-visits       ; Record of visited vendors
  spending-history    ; History of spending
  sustainability-preference ; Preference for eco-friendly options
  dao-voting-power    ; Voting power in DAO governance
]


;; Setup Procedures

to setup
  clear-all
  reset-ticks
  setup-parameters
  setup-green-spaces
  setup-nft-system
  create-agents
  initialize-plots
  setup-view
end

to setup-parameters
  set gch-price initial-gch-price
  set gch-supply initial-gch-supply
  set yearly-emission-rate 0.1  ; 10% yearly emission
  set last-emission-tick 0
  set market-sentiment 1.0

  set green-spaces table:make
  set gsst-prices table:make
  set revenue-pools table:make

  set price-history []
  set volume-history []
  set staking-history []
  set revenue-history []
  set nft-metrics-history []

  set bid-list []
  set ask-list []
  set total-volume 0
  set total-gch-staked 0

  ; NFT system parameters
  set nft-marketplace table:make
  set nft-prices table:make
  set nft-trading-fee 0.025  ; 2.5% fee on NFT trades
  set reputation-tiers table:make
  set nft-transaction-history []
  set nft-trade-volume 0
  set dao-governance table:make
  set total-dao-votes 0
  set nft-fund-allocation 0
  set nft-trade-radius 4  ; Slightly larger than token trade radius
end

to setup-nft-system
  ; Setup reputation tiers for vendors
  table:put reputation-tiers 1 "Standard"
  table:put reputation-tiers 2 "Bronze"
  table:put reputation-tiers 3 "Silver"
  table:put reputation-tiers 4 "Gold"
  table:put reputation-tiers 5 "Platinum"

  ; Initialize NFT marketplace with some base NFTs
  foreach ["Discount" "Access" "Reputation" "Event" "Governance"] [ nft-type ->
    table:put nft-marketplace nft-type []
    table:put nft-prices nft-type (10 + random 20)  ; Base price varies
  ]
end

to setup-green-spaces
  foreach ["Miyashita Park" "Yoyogi Park" "Shinjuku Gyoen" "Ueno Park"] [ name ->
    table:put green-spaces name (list
      (50 + random 50)    ; Initial customer base
      (100 + random 100)  ; Initial land value
      (random-float 1.0)  ; Quality score
    )
    table:put gsst-prices name initial-gsst-price
    table:put revenue-pools name 0
  ]
end

to create-agents
  create-investors initial-investors [
    setup-investor
  ]
  let num-spaces length table:keys green-spaces
  create-developers num-spaces [
    setup-developer
  ]
  create-consumers initial-consumers [
    setup-consumer
  ]
end

to setup-investor
  set color scale-color blue social-preference 0 1
  set shape "person"
  set gch-holdings random-normal (gch-supply / initial-investors) (gch-supply / initial-investors / 4)
  set gsst-holdings table:make
  set staked-amount 0
  set staking-period 0
  set social-preference random-float 1.0
  set trading-cooldown 0
  set activeness random-float 1
  set wealth gch-holdings * gch-price
  set bid-price 0
  set ask-price 0
  set bid-amount 0
  set ask-amount 0
  setxy random-xcor random-ycor

  ; NFT related properties
  set owned-nfts table:make
  set dao-voting-power 1  ; Base voting power
end

to setup-developer
  set color scale-color red quality-score 0 1
  set shape "house"
  ; Fix: Use modulo to cycle through available spaces
  set green-space-id item (who mod length table:keys green-spaces) table:keys green-spaces
  set gsst-supply initial-gsst-supply
  set quality-score random-float 1.0
  let space-data table:get green-spaces green-space-id
  set customer-base item 0 space-data
  set land-value item 1 space-data
  set maintenance-cost 50 + random 50
  set development-stage 1  ; Initialize development stage
  setxy random-xcor random-ycor

  ; NFT related properties
  set reputation-nft 1 + random 5  ; 1-5 star rating
  set issued-nfts table:make
  set sustainability-rating random-float 1.0
end

to setup-consumer
  set color scale-color green sustainability-preference 0 1
  set shape "face neutral"
  set spending-capacity 50 + random 100
  set preferred-spaces n-of (1 + random 3) table:keys green-spaces
  set gsst-holdings table:make

  ; NFT related properties
  set discount-nfts []
  set access-nfts []
  set reputation-nfts []
  set event-nfts []
  set governance-nfts []
  set event-participation 0
  set vendor-visits table:make
  set spending-history []
  set sustainability-preference random-float 1.0
  set dao-voting-power 0  ; Initialize voting power

  setxy random-xcor random-ycor
end

to setup-view
  ; Clear previous view settings
  clear-all-plots
  clear-patches

  ; Configure world and patches
  resize-world -16 16 -16 16  ; Standard NetLogo world size
  set-patch-size 15           ; Reasonable patch size for visibility

  ; Set up trading spots
  setup-trading-areas

  ; Initialize view-specific globals
  set trade-radius 3
  set movement-speed 0.5
  set current-traders []

  ; Position agents
  position-agents
end

to setup-trading-areas
  ; Create designated trading areas
  ask patches [
    ; Reset patch colors
    set pcolor black
  ]

  ; Initialize trade-spots as empty patch-set
  set trade-spots patch-set nobody

  ; Create trading spots (marked patches)
  ask n-of 5 patches with [
    distancexy 0 0 < 10 and    ; Keep trading spots within reasonable distance
    abs pxcor > 3 and          ; Avoid center congestion
    abs pycor > 3
  ] [
    set pcolor gray + 2
    set trade-spots (patch-set trade-spots self)
  ]
end

to position-agents
  ; Position investors
  ask investors [
    setxy random-xcor random-ycor
    while [any? other turtles-here] [
      setxy random-xcor random-ycor
    ]
    face one-of trade-spots
  ]

  ; Position developers
  ask developers [
    ; Position developers near their green spaces
    let angle random 360
    setxy (8 * sin angle) (8 * cos angle)  ; Create a rough circle
    while [any? other turtles-here] [
      set angle random 360
      setxy (8 * sin angle) (8 * cos angle)
    ]
  ]

  ; Position consumers
  ask consumers [
    setxy random-xcor random-ycor
    while [any? other turtles-here] [
      setxy random-xcor random-ycor
    ]
    face one-of trade-spots
  ]
end

to move-agents
  ask turtles [
    ifelse any? trade-spots [
      ; If there are trading spots, move towards them
      ifelse member? self current-traders [
        ; If currently trading, stay at trading spot
        if not member? patch-here trade-spots [  ; Fixed line
          move-to min-one-of trade-spots [distance myself]
        ]
      ] [
        ; If not trading, move around normally
        ifelse random 100 < 30 [  ; 30% chance to head towards trading spot
          face min-one-of trade-spots [distance myself]
        ] [
          ; Random movement
          rt random 50 - random 50
        ]
        forward movement-speed
      ]
    ] [
      ; If no trading spots, move randomly
      rt random 50 - random 50
      forward movement-speed
    ]
  ]

  ; Avoid overlapping
  ask turtles [
    if any? other turtles-here [
      rt 180
      forward 1
    ]
  ]
end

to update-agent-appearance
  ask investors [
    ; Update investor appearance based on wealth
    ; Handle negative or zero wealth with a minimum size
    ifelse wealth <= 0 [
      set size 0.5  ; Minimum size for investors with zero or negative wealth
    ] [
      set size 1 + (log wealth 10) / 4
    ]
    set color scale-color blue social-preference 0 1
  ]

  ask developers [
    ; Update developer appearance based on revenue
    ; Add 1 to revenue to handle zero revenue case
    set size 1 + (log (max list 1 revenue) 10) / 4
    set color scale-color red quality-score 0 1
  ]

  ask consumers [
    ; Update consumer appearance based on spending and sustainability
    set size 0.5 + (length (discount-nfts) + length (access-nfts) + length (reputation-nfts) + length (event-nfts) + length (governance-nfts)) / 20
    set color scale-color green sustainability-preference 0 1

    ; Change shape based on NFT ownership
    ifelse length (reputation-nfts) > 2 [
      set shape "face happy"
    ][
      set shape "face neutral"
    ]
  ]
end

to visualize-trades
  ; Clear old trading links
  ask links [ die ]

  ; Create temporary links for active trades
  ask investors with [
    bid-amount > 0 or ask-amount > 0
  ] [
    ; Find trading partners
    let potential-partners other investors with [
      distance myself <= trade-radius and
      ((bid-amount > 0 and [ask-amount] of myself > 0) or
       (ask-amount > 0 and [bid-amount] of myself > 0))
    ]

    if any? potential-partners [
      create-links-with potential-partners [
        set color yellow
        set thickness 0.2
      ]
    ]
  ]

  ; Visualize NFT trades
  ask consumers [
    ; Find developers with matching NFTs
    let potential-nft-partners developers with [
      distance myself <= nft-trade-radius and reputation-nft >= 3
    ]

    if any? potential-nft-partners and random 100 < 20 [
      create-links-with potential-nft-partners [
        set color violet
        set thickness 0.1
      ]
    ]
  ]

  ; Visualize investor NFT acquisition
  ask investors with [table:length owned-nfts > 0] [
    ; Link with developers who issued NFTs
    let nft-partners developers with [
      distance myself <= nft-trade-radius and reputation-nft >= 4
    ]

    if any? nft-partners and random 100 < 10 [
      create-links-with nft-partners [
        set color cyan
        set thickness 0.15
      ]
    ]
  ]
end

to update-view  ; Called from go procedure
  move-agents
  update-agent-appearance
  visualize-trades
end


;; Runtime Procedures

to go
  if ticks >= simulation-length [ stop ]

  update-market
  execute-trades
  process-emissions
  process-staking
  distribute-revenue

  ; Process NFT activities (no conditional check)
  process-nft-activities

  update-metrics
  update-view

  do-plots
  tick
end


;; Market Procedures

to update-market
  ask developers [
    update-green-space
  ]
  update-gsst-prices
  update-gch-price
  update-market-sentiment
  update-nft-prices
end


to update-green-space  ; developer context
  set customer-base customer-base * (1 + random-normal 0.01 0.005)
  set land-value land-value * (1 + random-normal 0.005 0.002)

  let new-revenue customer-base * quality-score * customer-spending
  table:put revenue-pools green-space-id (
    table:get revenue-pools green-space-id + new-revenue
  )

  if revenue * 0.2 > maintenance-cost [
    set quality-score min list 1.0 (quality-score + 0.01)
    set revenue revenue - maintenance-cost
  ]

  ; Update sustainability rating based on quality and investment
  ; Add check to prevent division by zero
  ifelse revenue > 0 [
    set sustainability-rating min list 1.0 (sustainability-rating +
      (quality-score * 0.01) + (maintenance-cost / revenue * 0.005))
  ] [
    ; Alternative calculation when revenue is zero
    set sustainability-rating min list 1.0 (sustainability-rating +
      (quality-score * 0.01))
  ]

  ; Occasionally advance development stage
  if random 100 < 2 and development-stage < 5 [
    set development-stage development-stage + 1
  ]
end

to update-gsst-prices
  foreach table:keys green-spaces [ g-space ->
    let new-price calculate-gsst-price g-space
    table:put gsst-prices g-space new-price
  ]
end

to update-gch-price
  let weighted-gsst-price mean table:values gsst-prices
  set gch-price weighted-gsst-price * (market-sentiment + random-normal 0 0.05)
end

to update-nft-prices
  ; Update NFT prices based on market activity and rarity
  foreach table:keys nft-prices [ nft-type ->
    let current-price table:get nft-prices nft-type
    let price-change random-normal 0 0.1  ; Random price fluctuation

    ; Adjust based on market sentiment
    set price-change price-change + ((market-sentiment - 1) * 0.2)

    ; Apply change
    table:put nft-prices nft-type (current-price * (1 + price-change))
  ]
end


to process-emissions
  ; Check if 12 ticks (1 year) have passed
  if ticks - last-emission-tick >= 12 and gch-supply <= 5000[
    ; Calculate new tokens to emit
    let new-tokens gch-supply * yearly-emission-rate

    ; Distribute new tokens to stakers proportionally
    if total-gch-staked > 0 [
      ask investors with [staked-amount > 0] [
        let share (staked-amount / total-gch-staked) * new-tokens
        set gch-holdings gch-holdings + share
        set wealth wealth + (share * gch-price)
      ]
    ]

    ; Update total supply
    set gch-supply gch-supply + new-tokens
    set last-emission-tick ticks
  ]
end

to update-market-sentiment
  set market-sentiment market-sentiment * (1 + random-normal 0 0.1)
  set market-sentiment max list 0.5 min list 2.0 market-sentiment
end


;; Trading Procedures

to execute-trades
  reset-trading-lists

  ask investors [
    if trading-cooldown <= 0 [
      trade-tokens
      set trading-cooldown 0
    ]
    set trading-cooldown trading-cooldown - 1
  ]

  process-orders
end

to reset-trading-lists
  set bid-list []
  set ask-list []
  ask investors [
    set bid-price 0
    set ask-price 0
    set bid-amount 0
    set ask-amount 0
  ]
end

to trade-tokens  ; investor context
  let target-gch optimal-gch-holdings
  let diff target-gch - gch-holdings

  if abs diff > min-trade-size [
    ifelse diff > 0
    [ place-buy-order diff ]
    [ place-sell-order (abs diff) ]
  ]
end

to place-buy-order [amount]  ; investor context
  let max-purchase wealth / gch-price
  let order-amount min list amount max-purchase

  if order-amount >= min-trade-size [
    set bid-amount order-amount
    set bid-price gch-price * (1 + random-float 0.2)
    set bid-list lput bid-price bid-list
  ]
end

to place-sell-order [amount]  ; investor context
  let available-amount gch-holdings - staked-amount
  let order-amount min list amount available-amount

  if order-amount >= min-trade-size [
    set ask-amount order-amount
    set ask-price gch-price * (1 - random-float 0.2)
    set ask-list lput ask-price ask-list
  ]
end

to process-orders
  if empty? bid-list or empty? ask-list [ stop ]

  set bid-list sort-by > bid-list
  set ask-list sort ask-list

  let match-price (item 0 bid-list + item 0 ask-list) / 2
  let volume min (list length bid-list length ask-list)

  if volume > 0 [
    execute-trades-at-price match-price volume
  ]
end

to execute-trades-at-price [price volume]
  let remaining volume

  ask investors with [ask-amount > 0] [
    if remaining > 0 [
      let trade-amount min list ask-amount remaining
      set gch-holdings gch-holdings - trade-amount
      set wealth wealth + (trade-amount * price)
      set remaining remaining - trade-amount
    ]
  ]

  set remaining volume

  ask investors with [bid-amount > 0] [
    if remaining > 0 [
      let trade-amount min list bid-amount remaining
      set gch-holdings gch-holdings + trade-amount
      set wealth wealth - (trade-amount * price)
      set remaining remaining - trade-amount
    ]
  ]

  set total-volume total-volume + volume
end

;; Staking Procedures

to process-staking
  ; Reset total staked amount
  set total-gch-staked 0

  ; Process each investor's staking
  ask investors [
    if gch-holdings > 0 [
      ; Ensure staked amount doesn't exceed holdings
      set staked-amount min list staked-amount gch-holdings
      update-staking-position
    ]
  ]

  ; Ensure total staked never exceeds supply
  if total-gch-staked > gch-supply [
    let scale-factor gch-supply / total-gch-staked
    ask investors [
      set staked-amount staked-amount * scale-factor
    ]
    set total-gch-staked gch-supply
  ]
end

to update-staking-position  ; investor context
  ifelse staked-amount > 0
  [ set staking-period staking-period + 1 ]
  [ consider-new-stake ]

  if staking-period >= 60 [
    consider-unstaking
  ]

  set total-gch-staked total-gch-staked + staked-amount
end

to consider-new-stake  ; investor context
  ; Calculate maximum possible stake (70% of holdings)
  let max-stake gch-holdings * 0.7
  ; Calculate remaining stakeable supply
  let available-for-staking gch-supply - total-gch-staked
  ; Take minimum of desired stake and available supply
  let optimal-stake min list max-stake available-for-staking

  if gch-holdings >= min-trade-size and optimal-stake > 0 [
    set staked-amount optimal-stake
    set staking-period 0
  ]
end

to consider-unstaking  ; investor context
  if random-float 1 < 0.1 [
    let unstake-amount staked-amount
    set gch-holdings gch-holdings + unstake-amount
    set staked-amount 0
    set staking-period 0
  ]
end

;; Revenue Distribution

to distribute-revenue
  foreach table:keys revenue-pools [ g-space ->
    let pool table:get revenue-pools g-space
    if pool > 0 [
      distribute-space-revenue g-space pool
    ]
  ]
end

to distribute-space-revenue [g-space pool]
  let staker-share pool * revenue-share
  let dev-share pool * (1 - revenue-share)

  if total-gch-staked > 0 [
    ask investors with [staked-amount > 0] [
      let share (staked-amount / total-gch-staked) * staker-share
      set total-benefits total-benefits + share
      set wealth wealth + share
    ]
  ]

  ask developers with [green-space-id = g-space] [
    set revenue revenue + dev-share
  ]

  table:put revenue-pools g-space 0
end

;; NFT System Procedures

to process-nft-activities
  ; Consumer NFT activities
  ask consumers [
    consumer-shopping
    consider-nft-purchases
  ]

  ; Developer NFT activities
  ask developers [
    update-reputation-rating
    issue-event-nfts
  ]

  ; Investor NFT activities
  ask investors [
    investor-acquire-nfts
  ]

  ; Process NFT trading
  process-nft-trades

  ; Update DAO governance
  update-dao-governance

  ; Allocate NFT funds to green spaces
  allocate-nft-funds

  ; Implement GCH to NFT conversion mechanisms
  process-gch-to-nft-conversions
end

to consumer-shopping  ; consumer context
  ; Simulate consumer spending at vendors
  if random 100 < 75 [  ;
    let preferred-space one-of preferred-spaces
    let target-developer one-of developers with [green-space-id = preferred-space]

    if target-developer != nobody [
      ; Record visit
      ifelse not table:has-key? vendor-visits [who] of target-developer [
        table:put vendor-visits [who] of target-developer 1
      ] [
        table:put vendor-visits [who] of target-developer (
          table:get vendor-visits [who] of target-developer + 1
        )
      ]

      ; Calculate spending amount influenced by sustainability preference and NFTs
      let spending-amount spending-capacity * (0.1 + random-float 0.4)

      ; Apply discounts from NFTs
      if length discount-nfts > 0 [
        set spending-amount spending-amount * (1 - 0.05 * length discount-nfts)
      ]

      ; Record spending
      set spending-history lput spending-amount spending-history

      ; Update developer's revenue and customer base
      ask target-developer [
        set revenue revenue + spending-amount
        set customer-base customer-base + 0.01

        ; Consumer might earn GSST based on spending
        if reputation-nft >= 3 and random 100 < 30 [
          ; Earns GSST proportional to spending
          if not table:has-key? [gsst-holdings] of myself green-space-id [
            table:put [gsst-holdings] of myself green-space-id 0
          ]

          let gsst-earned spending-amount / 100  ; 1% of spending as GSST
          table:put [gsst-holdings] of myself green-space-id (
            table:get [gsst-holdings] of myself green-space-id + gsst-earned
          )
        ]
      ]

      ; Chance to earn reputation NFT with frequent visits - reduced from 5 to 3 visits, increased chance from 20% to 30%
      if table:has-key? vendor-visits [who] of target-developer and
         table:get vendor-visits [who] of target-developer >= 3 and random 100 < 30 [
        if not member? preferred-space reputation-nfts [
          set reputation-nfts lput preferred-space reputation-nfts
        ]
      ]
    ]
  ]
end

to consider-nft-purchases  ; consumer context

  if random 100 < 75 and length (table:keys gsst-holdings) > 0 [
    let nft-type one-of table:keys nft-prices
    let nft-price table:get nft-prices nft-type

    ; Lower threshold for purchases - more sustainability-conscious
    if spending-capacity > nft-price * 0.7 and random-float 1 < (sustainability-preference * 1.5) [
      ; Purchase the NFT
      set spending-capacity spending-capacity - nft-price

      ; Allocate NFT based on type
      if nft-type = "Discount" [
        set discount-nfts lput (word "Discount-" (length discount-nfts + 1)) discount-nfts
      ]
      if nft-type = "Access" [
        set access-nfts lput (word "Access-" (length access-nfts + 1)) access-nfts
      ]
      if nft-type = "Reputation" [
        set reputation-nfts lput (word "Rep-" (length reputation-nfts + 1)) reputation-nfts
      ]
      if nft-type = "Event" [
        set event-nfts lput (word "Event-" (length event-nfts + 1)) event-nfts
      ]
      if nft-type = "Governance" [
        set governance-nfts lput (word "Gov-" (length governance-nfts + 1)) governance-nfts
      ]

      ; Record transaction for fees
      set nft-transaction-history lput nft-price nft-transaction-history
    ]
  ]
end

to investor-acquire-nfts  ; investor context
  ; Investors can acquire NFTs with their GCH holdings
  if random 100 < 5 and gch-holdings > 20 [  ; 5% chance
    let nft-type one-of table:keys nft-prices
    let nft-price table:get nft-prices nft-type

    ; Check if investor can afford
    if gch-holdings > nft-price * 2 [  ; Ensure enough buffer
      ; Purchase the NFT
      set gch-holdings gch-holdings - nft-price

     ; Record ownership
      if not table:has-key? owned-nfts nft-type [
        table:put owned-nfts nft-type 0
      ]
      table:put owned-nfts nft-type (table:get owned-nfts nft-type + 1)

      ; Record transaction for fees
      set nft-transaction-history lput nft-price nft-transaction-history

      ; Increase voting power based on NFT type
      ifelse nft-type = "Governance" [
        set dao-voting-power dao-voting-power + 2  ; Governance NFTs grant more voting power
      ] [
        set dao-voting-power dao-voting-power + 0.5  ; Other NFTs grant some voting power
      ]
    ]
  ]
end

to update-reputation-rating  ; developer context
  ; Update reputation based on sustainability rating and customer base
  let new-rating floor (sustainability-rating * 5) + 1

  ; Ensure rating is between 1-5
  set reputation-nft max list 1 min list 5 new-rating

  ; Reputation affects quality score
  set quality-score quality-score + (reputation-nft / 100)
end

to issue-event-nfts  ; developer context
  ; Occasionally issue event NFTs
  if random 100 < 5 and reputation-nft >= 3 [  ; 5% chance for high-rated developers
    ; Identify potential customers (recently visited)
    let recent-customers consumers with [
      table:has-key? vendor-visits [who] of myself and
      table:get vendor-visits [who] of myself >= 3
    ]

    if any? recent-customers [
      ask up-to-n-of 3 recent-customers [
        ; Issue event NFT
        set event-participation event-participation + 1

        ; If completed multiple events, reward with special NFT
        if event-participation >= 3 and random 100 < 50 [
          ; Use the developer's green space ID
          set access-nfts lput (word "VIP-" [green-space-id] of myself) access-nfts
        ]

        ; Also offer event NFTs
        if random 100 < 40 [
          set event-nfts lput (word "Event-" [green-space-id] of myself "-" event-participation) event-nfts
        ]
      ]
    ]
  ]
end

to process-nft-trades
  ; Process secondary market NFT trades
  if length nft-transaction-history > 0 [
    let total-trades length nft-transaction-history
    let trade-volume sum nft-transaction-history

    ; Calculate fees generated
    let fees trade-volume * nft-trading-fee

    ; Add to fund allocation
    set nft-fund-allocation nft-fund-allocation + fees

    ; Update NFT trade volume metric
    set nft-trade-volume nft-trade-volume + trade-volume
  ]

  ; Reset transaction history for next tick
  set nft-transaction-history []
end

to update-dao-governance
  ; Update governance based on NFT holdings and staking
  set total-dao-votes 0

  ; Calculate voting power for investors
  ask investors with [staked-amount > 0] [
    ; Base voting power from staking
    let vote-power staked-amount / 100

    ; Additional power from NFTs
    if table:length owned-nfts > 0 [
      set vote-power vote-power * (1 + table:length owned-nfts / 10)
    ]

    ; Update investor's voting power
    set dao-voting-power vote-power
    set total-dao-votes total-dao-votes + vote-power
  ]

  ; Consumers with reputation NFTs get some voting rights
  ask consumers with [length reputation-nfts > 0 or length governance-nfts > 0] [
    let rep-power length reputation-nfts * 0.5
    let gov-power length governance-nfts * 2  ; Governance NFTs have more weight
    set dao-voting-power rep-power + gov-power
    set total-dao-votes total-dao-votes + dao-voting-power
  ]
end

to allocate-nft-funds
  ; Allocate collected NFT fees to green spaces
  if nft-fund-allocation > 0 [
    let allocation-per-space nft-fund-allocation / length table:keys green-spaces

    foreach table:keys green-spaces [ g-space ->
      let current-pool table:get revenue-pools g-space
      table:put revenue-pools g-space (current-pool + allocation-per-space)
    ]

    ; Reset allocation
    set nft-fund-allocation 0
  ]
end

to process-gch-to-nft-conversions
  ; This procedure implements direct GCH to NFT conversions
  ; Occasionally investors may convert GCH to NFTs
  ask investors with [gch-holdings > 50] [
    if random 100 < 2 [  ; 2% chance
      ; Randomly select an NFT type
      let nft-type one-of ["Discount" "Access" "Reputation" "Event" "Governance"]
      let conversion-rate 10  ; GCH tokens per NFT

      ; Perform conversion
      if gch-holdings >= conversion-rate [
        set gch-holdings gch-holdings - conversion-rate

        ; Add to owned NFTs
        if not table:has-key? owned-nfts nft-type [
          table:put owned-nfts nft-type 0
        ]
        table:put owned-nfts nft-type (table:get owned-nfts nft-type + 1)

        ; Update DAO voting power for governance NFTs
        if nft-type = "Governance" [
          set dao-voting-power dao-voting-power + 2
        ]
      ]
    ]
  ]
end

;; Utility Functions

to-report calculate-gsst-price [g-space]
  let space-data table:get green-spaces g-space
  let cust-base item 0 space-data
  let land-val item 1 space-data
  let qual-score item 2 space-data

  let intrinsic-value (cust-base * customer-spending + land-val * 0.05) * (1 + qual-score)
  let revenue-component table:get revenue-pools g-space * revenue-share
  let supply [gsst-supply] of one-of developers with [green-space-id = g-space]

  ; Add NFT factor to price calculation
  let nft-factor 1.0
  ask developers with [green-space-id = g-space] [
    ; Reputation NFT increases value
    set nft-factor nft-factor + (reputation-nft / 10)
  ]

  report (intrinsic-value + revenue-component) / supply * nft-factor
end

to-report optimal-gch-holdings  ; investor context
  let expected-return (mean table:values gsst-prices) / gch-price - 1
  let risk-factor (random-normal 0.5 1.5) * market-sentiment

  ; Add NFT influence to investment decisions
  let nft-influence 1.0
  if table:length owned-nfts > 0 [
    set nft-influence 1.0 + (table:length owned-nfts * 0.05)  ; 5% increase per NFT
  ]

  let optimal (gch-supply * (random-normal 0.001 0.01)) * (1 + expected-return) * risk-factor * nft-influence
  report max list 0 optimal
end

;; Metrics and Plotting

to update-metrics
  update-price-metrics
  update-volume-metrics
  update-staking-metrics
  update-revenue-metrics
  update-nft-metrics
end

to update-price-metrics
  set price-history lput gch-price price-history
  if length price-history > 100 [
    set price-history but-first price-history
  ]
end

to update-volume-metrics
  set volume-history lput total-volume volume-history
  if length volume-history > 100 [
    set volume-history but-first volume-history
  ]
end

to update-staking-metrics
  set staking-history lput (total-gch-staked / gch-supply) staking-history
  if length staking-history > 100 [
    set staking-history but-first staking-history
  ]
end

to update-revenue-metrics
  set revenue-history lput mean [revenue] of developers revenue-history
  if length revenue-history > 100 [
    set revenue-history but-first revenue-history
  ]
end

to update-nft-metrics
  ; Calculate and store NFT metrics in global variables
  set total-consumer-nfts sum [length discount-nfts + length access-nfts + length reputation-nfts] of consumers
  set total-investor-nfts sum [table:length owned-nfts] of investors
  set avg-developer-rating mean [reputation-nft] of developers
  set total-nfts total-consumer-nfts + total-investor-nfts
end

to initialize-plots
  setup-price-plot
  setup-volume-plot
  setup-revenue-plot
  setup-sentiment-plot
  setup-nft-plot
  setup-dao-plot
end

to setup-price-plot
  set-current-plot "Token Prices"
  clear-plot
  set-plot-x-range 0 100
  set-plot-y-range 0 (initial-gch-price * 3)
  create-temporary-plot-pen "GCH"
  set-plot-pen-color blue
end

to setup-volume-plot
  set-current-plot "Trading Volume"
  clear-plot
  set-plot-x-range 0 100
  set-plot-y-range 0 1000
  create-temporary-plot-pen "Token Volume"
  set-plot-pen-color green
  create-temporary-plot-pen "NFT Volume"
  set-plot-pen-color violet
end

to setup-revenue-plot
  set-current-plot "Revenue"
  clear-plot
  set-plot-x-range 0 100
  set-plot-y-range 0 1000
  create-temporary-plot-pen "Avg Revenue"
  set-plot-pen-color red
end

to setup-sentiment-plot
  set-current-plot "Market Sentiment"
  clear-plot
  set-plot-x-range 0 100
  set-plot-y-range 0 2
  create-temporary-plot-pen "Sentiment"
  set-plot-pen-color yellow
end

to setup-nft-plot
  set-current-plot "NFT System Metrics"
  clear-plot
  set-plot-x-range 0 100
  set-plot-y-range 0 100
  create-temporary-plot-pen "Developer Ratings"
  set-plot-pen-color green
  create-temporary-plot-pen "Consumer NFTs"
  set-plot-pen-color violet
  create-temporary-plot-pen "Total NFTs"
  set-plot-pen-color cyan
end

to setup-dao-plot
  set-current-plot "DAO Governance"
  clear-plot
  set-plot-x-range 0 100
  set-plot-y-range 0 100
  create-temporary-plot-pen "Total Votes"
  set-plot-pen-color blue
  create-temporary-plot-pen "Investor Votes"
  set-plot-pen-color orange
  create-temporary-plot-pen "Consumer Votes"
  set-plot-pen-color green
end

to do-plots
  ; Token Prices plot
  set-current-plot "Token Prices"
  plot gch-price

  ; Trading Volume plot
  set-current-plot "Trading Volume"
  set-current-plot-pen "Token Volume"
  plot total-volume
  set-current-plot-pen "NFT Volume"
  plot nft-trade-volume / 10  ; Scale down for visibility

  ; Revenue plot
  set-current-plot "Revenue"
  plot mean [revenue] of developers

  ; Sentiment Plot
  set-current-plot "Market Sentiment"
  plot market-sentiment

  ; NFT System Plot
  set-current-plot "NFT System Metrics"
  set-current-plot-pen "Developer Ratings"
  plot mean [reputation-nft] of developers * 10  ; Scale to make visible
  set-current-plot-pen "Consumer NFTs"
  plot mean [length discount-nfts + length access-nfts + length reputation-nfts + length event-nfts + length governance-nfts] of consumers * 5
  set-current-plot-pen "Total NFTs"
  plot total-nfts

  ; DAO Governance Plot
  set-current-plot "DAO Governance"
  set-current-plot-pen "Total Votes"
  plot total-dao-votes
  set-current-plot-pen "Investor Votes"
  plot sum [dao-voting-power] of investors
  set-current-plot-pen "Consumer Votes"
  plot sum [dao-voting-power] of consumers
end
@#$#@#$#@
GRAPHICS-WINDOW
219
10
722
514
-1
-1
15.0
1
10
1
1
1
0
1
1
1
-16
16
-16
16
0
0
1
ticks
30.0

SLIDER
25
10
197
43
initial-gch-price
initial-gch-price
0.1
10
9.1
1
1
NIL
HORIZONTAL

SLIDER
25
52
197
85
initial-gch-supply
initial-gch-supply
1000
1000000
1000.0
1000
1
NIL
HORIZONTAL

SLIDER
25
95
197
128
initial-gsst-price
initial-gsst-price
0.1
10
1.1
1
1
NIL
HORIZONTAL

SLIDER
26
184
198
217
initial-investors
initial-investors
10
1000
363.0
1
1
NIL
HORIZONTAL

SLIDER
25
139
197
172
initial-gsst-supply
initial-gsst-supply
1000
100000
1000.0
1000
1
NIL
HORIZONTAL

SLIDER
26
361
198
394
simulation-length
simulation-length
100
10000
400.0
100
1
NIL
HORIZONTAL

SLIDER
26
317
206
350
customer-spending
customer-spending
1
100
30.0
1
1
NIL
HORIZONTAL

SLIDER
26
405
198
438
min-trade-size
min-trade-size
1
100
1.0
1
1
NIL
HORIZONTAL

SLIDER
26
274
198
307
revenue-share
revenue-share
0
1
0.8
0.1
1
NIL
HORIZONTAL

PLOT
732
10
932
160
Token Prices
Time
Price
0.0
100.0
0.0
10.0
true
false
"" ""
PENS
"GCH" 1.0 0 -13345367 true "" "plot gch-price"

BUTTON
219
519
285
552
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
290
519
353
552
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
359
519
422
552
1tick
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
731
170
931
320
Trading Volume
Time
Volume
0.0
100.0
0.0
1000.0
true
false
"" ""
PENS
"Token Volume" 1.0 0 -13840069 true "" "plot total-volume"
"NFT Volume" 1.0 0 -7500403 true "" " plot nft-trade-volume / 10"

PLOT
731
488
931
638
Revenue
Time
Revenue
0.0
100.0
0.0
1000.0
true
false
"" ""
PENS
"Avg Revenue" 1.0 0 -2674135 true "" "plot mean [revenue] of developers"

MONITOR
937
10
1011
55
GCH Price
precision gch-price 3
3
1
11

MONITOR
937
170
1031
215
Total Volume
precision total-volume 0
0
1
11

MONITOR
937
488
1056
533
Average Revenue
precision mean [revenue] of developers 2
2
1
11

PLOT
731
326
931
476
Market Sentiment
Time
Sentiment 
0.0
100.0
0.0
2.0
true
false
"" ""
PENS
"Sentiment" 1.0 0 -1184463 true "" "plot market-sentiment "

MONITOR
939
329
1044
374
Market Sentiment
precision market-sentiment 3
3
1
11

SLIDER
25
227
197
260
initial-consumers
initial-consumers
10
1000
369.0
1
1
NIL
HORIZONTAL

PLOT
1069
10
1269
160
NFT System Metrics
NIL
NIL
0.0
100.0
0.0
100.0
true
false
"" ""
PENS
"Developer Ratings" 1.0 0 -10899396 true "" "plot mean [reputation-nft] of developers * 10 "
"Consumer NFTs" 1.0 0 -8630108 true "" "plot mean [length discount-nfts + length access-nfts + length reputation-nfts + length event-nfts + length governance-nfts] of consumers * 5"
"Total NFTs" 1.0 0 -11221820 true "" "plot total-nfts"

PLOT
1069
167
1269
317
DAO Governance
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"Total Votes" 1.0 0 -10899396 true "" "plot total-dao-votes"
"Investor Votes" 1.0 0 -8630108 true "" "plot sum [dao-voting-power] of investors"
"Consumer Votes" 1.0 0 -11221820 true "" "plot sum [dao-voting-power] of consumers"

MONITOR
1275
11
1453
56
Developer Ratings (GREEN)
mean [reputation-nft] of developers * 10
3
1
11

MONITOR
1275
63
1479
108
Mean Consumer NFTs (VIOLET)
mean [length discount-nfts + length access-nfts + length reputation-nfts + length event-nfts + length governance-nfts] of consumers * 5
3
1
11

MONITOR
1275
116
1402
161
Total NFTs (CYAN)
total-nfts
3
1
11

MONITOR
1275
168
1410
213
Total Votes (GREEN)
total-dao-votes
3
1
11

MONITOR
1275
220
1433
265
Investor Votes (VIOLET)
sum [dao-voting-power] of investors
3
1
11

MONITOR
1275
272
1439
317
Consumer Votes (CYAN)
sum [dao-voting-power] of consumers
3
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
