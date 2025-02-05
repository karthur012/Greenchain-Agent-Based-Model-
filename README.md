# Green Space Tokenization Simulation

A NetLogo agent-based simulation modeling the tokenization of green spaces using a dual-token system (GCH and GSST).

## Overview

This simulation models a tokenized green space ecosystem where:
- Green spaces (parks) are represented by space-specific tokens (GSST)
- A governance token (GCH) enables participation in the ecosystem
- Investors and developers interact through trading and staking mechanisms
- Revenue is generated from customer visits and distributed to stakeholders

## Features

- **Dual Token System**
  - GCH: Governance token with staking mechanics
  - GSST: Space-specific tokens representing individual parks

- **Agent Types**
  - Investors: Trade tokens and stake GCH
  - Developers: Manage green spaces and generate revenue

- **Economic Mechanics**
  - Dynamic price discovery
  - Revenue sharing system
  - Token emissions
  - Staking rewards
  - Market sentiment effects

- **Visualization**
  - Real-time price charts
  - Trading volume metrics
  - Revenue tracking
  - Market sentiment indicators

## Setup Instructions

1. Install [NetLogo](https://ccl.northwestern.edu/netlogo/)
2. Open the simulation file in NetLogo
3. Adjust parameters using the interface sliders
4. Click "Setup" to initialize
5. Click "Go" to run the simulation

## Parameters

### Initial Settings
- `initial-gch-price`: Starting price for GCH token
- `initial-gch-supply`: Initial supply of GCH tokens
- `initial-gsst-price`: Starting price for GSST tokens
- `initial-gsst-supply`: Initial supply of each GSST
- `initial-investors`: Number of investor agents
- `customer-spending`: Average spending per customer
- `revenue-share`: Percentage of revenue shared with stakers

### Runtime Parameters
- `simulation-length`: Duration of simulation
- `min-trade-size`: Minimum trade amount
- `yearly-emission-rate`: Rate of new token creation

## Metrics

The simulation tracks several key metrics:
- Token prices
- Trading volume
- Staking ratio
- Revenue generation
- Market sentiment

## Implementation Details

### Key Components

1. **Market Mechanism**
   - Price discovery based on supply/demand
   - Market sentiment influences
   - Trading at designated spots

2. **Revenue System**
   - Customer-based revenue generation
   - Quality-based multipliers
   - Maintenance cost considerations

3. **Staking Mechanism**
   - Proportional revenue sharing
   - Emission rewards
   - Lock-up periods

4. **Agent Behavior**
   - Risk-based trading decisions
   - Social preference influences
   - Dynamic movement patterns

## Contributing

Feel free to fork this repository and suggest improvements. Some areas for potential enhancement:

- Additional economic parameters
- More sophisticated trading strategies
- Enhanced visualization features
- Additional market mechanics

## Credits

Created by Kaoru Takashima, Teru Sanami 
Based on research into tokenized real estate and green space management

## Contact

kaoru.takashima@keio.jp 
