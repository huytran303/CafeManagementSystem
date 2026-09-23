# Diagrams

PlantUML sources for the use case model in
[`../BrewBoss_UseCase_Specifications.docx`](../BrewBoss_UseCase_Specifications.docx) (41 use cases,
UC01–UC41), derived from [`../product-brief.md`](../product-brief.md).

| File | Scope | Use cases |
|---|---|---|
| `D0_SystemContext.puml` | actors, the 9 modules, the 3 external systems | — |
| `D1_AuthStaff.puml` | log in / out, password reset, staff accounts, shifts | UC01–UC06 |
| `D2_MenuInventory.puml` | categories, products, availability, ingredients, stock, recipes | UC07–UC17 |
| `D3_PointOfSale.puml` | tables, orders, discount, payment, cancel, receipt, shop settings | UC18–UC29 |
| `D4_BaristaCustomer.puml` | barista queue, ready notification, table-QR ordering | UC30–UC33 |
| `D5_ReportsLoyalty.puml` | dashboard, order history, reports, loyalty, vouchers | UC34–UC41 |

Every use case UC01–UC41 is owned by exactly one diagram. A use case shown on another diagram is
repeated with a `(see Dx)` suffix so the `<<include>>`/`<<extend>>` relationship stays visible
without duplicating ownership.

Every file is self-contained: it declares its own skinparams and renders on its own, with no
shared include.

## Conventions

- **Visual Paradigm look.** Actors are stick figures, use cases are plain white ellipses with
  a short verb phrase, the system boundary is one `BrewBoss` rectangle, and every connector is a
  straight line (`skinparam linetype polyline`). No notes on the diagrams.
- **Short labels.** Each use case shows its id on the first line and a 2–4 word name on the
  second; the full titles are in the specification document.
- **One diagram per module group.** A single diagram holding all 41 use cases does not fit a page.
- **Only three relationship types are drawn:** actor associations, `<<include>>` and
  `<<extend>>`. The order flow (brief §4.1) and the order state machine (brief §4.2) are
  sequence, not use case relationships, and stay in the specifications.
- **Relationship direction** follows UML: the dashed arrow points from the including use case
  to the included one, and from the extending use case to the base it extends.
- **`<<include>>`** is drawn only where a specification names another use case as a mandatory
  step of its flow:

  | Base | includes | Source |
  |---|---|---|
  | UC20 Create order | UC10 Browse & search menu | UC20 step 2: "browses the menu (UC10)" |
  | UC32 Order via table QR | UC10 Browse & search menu | UC32 step 3: "browses the menu (UC10)" |
  | UC25 Take payment | UC15 Deduct stock by recipe | UC15 trigger: "included in UC25 (payment transaction)" |

- **`<<extend>>`** is drawn only where a specification names an optional or conditional
  continuation into another use case:

  | Extension | extends base | Source |
  |---|---|---|
  | UC14 Define recipe | UC08 Manage products | UC08 alt 5a: "continues to the recipe section" |
  | UC16 Send low-stock alert | UC15 Deduct stock by recipe | UC15 step 4: stock ≤ min stock after deduction |
  | UC16 Send low-stock alert | UC13 Record stock adjustment | UC16 trigger: "after UC15 or UC13" |
  | UC24 Apply discount | UC25 Take payment | UC25 step 2: "optionally … applies a discount" |
  | UC38 Attach loyalty customer | UC25 Take payment | UC25 step 2: "optionally attaches a loyalty customer" |
  | UC39 Redeem points | UC25 Take payment | UC25 step 2: "optionally … redeems points" |
  | UC28 View & share receipt | UC25 Take payment | UC25 step 6: "with a receipt option" |
  | UC28 View & share receipt | UC35 View order history | UC35 alt 3a: paid order → "Hóa đơn" |
  | UC27 Cancel order | UC22 Confirm customer order | UC22 alt 3a: "Cashier rejects the order" |
  | UC31 Notify order ready | UC30 Process order queue | UC30 step 5: status = ready |
  | UC33 Track order status | UC32 Order via table QR | UC32 alt 6a: "Order tracking (P2) is built" |
  | UC37 Export report | UC36 View sales reports | UC36 alt 5a: "Manager taps Xuất" |

- **Actor generalization.** `Staff` is abstract; `Cashier`, `Barista` and `Manager` specialize it
  (drawn on D1 only). Per brief §2, `Manager` also holds every Cashier and Barista permission; this
  is not drawn, so D3 and D5 show only the lowest role that performs each use case.
- **External actors** are Firebase Auth (UC01, UC03, UC32), Firebase Cloud Messaging (UC16,
  UC31) and VietQR (UC25), drawn to the right of the frame beside the use case that calls them.
- **System use cases.** UC15, UC16 and UC31 have no human primary actor: UC15 is reached only
  through `<<include>>` from UC25, and UC16 / UC31 are extensions that talk to Firebase Cloud
  Messaging.
- **Layout-only constructs** (none carries meaning): the invisible `<<inner>>` rectangle inside
  `BrewBoss` adds padding so no ellipse touches the frame; `.[norank].>` only keeps both ends of an
  `<<extend>>` in the same column; `together { }` on D3 keeps related use cases next to each other.

## draw.io diagrams

Open with [diagrams.net](https://app.diagrams.net) or the VS Code draw.io extension.

| File | Document | Scope |
|---|---|---|
| `context-diagram.drawio` | SRS | System context: actors and data flows around BrewBoss |
| `order-flow.drawio` | SRS | Vertical swimlane flowchart of the order lifecycle (brief §4.1, §4.3) |
| `screen-flow.drawio` | SRS / SDS UI | Navigation graph of screens S01–S22 with go_router paths (brief §8) |
| `order-state-machine.drawio` | SDS | Order status state machine (brief §4.2) |

## Rendering

```bash
# all diagrams into images/ (PNG for documents)
plantuml -tpng -o images *.puml

# single diagram as SVG (for the web)
plantuml -tsvg -o images D3_PointOfSale.puml
```

Each diagram's internal name is prefixed `BB_`, so the output files are
`images/BB_D0_SystemContext.png` and so on. The images are generated from the `.puml` sources;
re-render after editing.
