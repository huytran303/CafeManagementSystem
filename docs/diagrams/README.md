# Diagrams

PlantUML sources for the use case model in
[`../BrewBoss_UseCase_Specifications.docx`](../BrewBoss_UseCase_Specifications.docx) (46 use cases,
UC01–UC46), derived from [`../product-brief.md`](../product-brief.md).

`use-case-diagrams.drawio` holds the same six diagrams as draw.io pages (D0–D5), and
`use-case-by-actor.drawio` holds the per-actor diagrams (A1–A5); open them at
[app.diagrams.net](https://app.diagrams.net).

| File | Scope | Use cases |
|---|---|---|
| `D0_SystemContext.puml` | actors, the 9 modules, the 3 external systems | — |
| `D1_AuthStaff.puml` | log in / out, password reset, staff accounts, shifts, cash handover | UC01–UC06, UC44–UC45 |
| `D2_MenuInventory.puml` | categories, products, availability, ingredients, stock, recipes, stocktake, cancel waste | UC07–UC17, UC42–UC43 |
| `D3_PointOfSale.puml` | tables, orders, voucher, payment, split payment, cancel, receipt, shop settings | UC18–UC29, UC46 |
| `D4_BaristaCustomer.puml` | barista queue, ready notification, table-QR ordering | UC30–UC33 |
| `D5_ReportsLoyalty.puml` | dashboard, order history, reports, loyalty, vouchers | UC34–UC41 |

The same model is also drawn per actor (A1–A5), one diagram per actor showing everything that
actor starts plus the use cases those reach through `<<include>>` / `<<extend>>`:

| File | Actor | Use cases |
|---|---|---|
| `A1_Staff.puml` | Staff (abstract; Cashier, Barista, Manager inherit it) | UC01–UC03, UC05, UC10; reaches UC44 |
| `A2_Cashier.puml` | Cashier | UC09, UC19–UC28, UC38–UC39; reaches UC15, UC16, UC43, UC46; repeats UC05 → UC44 from A1 |
| `A3_Barista.puml` | Barista | UC30–UC31 |
| `A4_Customer.puml` | Customer | UC10, UC32–UC33 |
| `A5_Manager.puml` | Manager | UC04, UC06–UC08, UC11–UC14, UC17–UC18, UC29, UC34–UC37, UC40–UC42, UC45 |

On A2 the payment extensions (UC24, UC28, UC38, UC39, UC46) hang off UC25 only, without a direct
Cashier line, so no dashed arrow crosses an actor association. A5 lists only Manager-only use
cases; the Cashier and Barista permissions the Manager also holds (brief §2) are on A2 / A3.
UC44 sits on A1 because UC05 includes it; A2 repeats UC05 and UC44 with `(see A1)` since cash
handover matters for the Cashier (and Manager) only; a Barista shift has no cash fields (BR-STAFF-03).

Every use case UC01–UC46 is owned by exactly one diagram. A use case shown on another diagram is
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
- **One diagram per module group.** A single diagram holding all 46 use cases does not fit a page.
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
  | UC05 Check in / out shift | UC44 Hand over cash | UC05 step 5: "System runs UC44 (include)" for a cashier or manager |

- **`<<extend>>`** is drawn only where a specification names an optional or conditional
  continuation into another use case:

  | Extension | extends base | Source |
  |---|---|---|
  | UC14 Define recipe | UC08 Manage products | UC08 alt 5a: "continues to the recipe section" |
  | UC16 Send low-stock alert | UC15 Deduct stock by recipe | UC15 step 4: stock ≤ min stock after deduction |
  | UC16 Send low-stock alert | UC13 Record stock adjustment | UC16 trigger: "after UC15 or UC13" |
  | UC24 Apply voucher | UC25 Take payment | UC25 step 2: "optionally … applies a voucher" |
  | UC38 Attach loyalty customer | UC25 Take payment | UC25 step 2: "optionally attaches a loyalty customer" |
  | UC39 Redeem points | UC25 Take payment | UC25 step 2: "optionally … redeems points" |
  | UC28 View & share receipt | UC25 Take payment | UC25 step 6: "with a receipt option" |
  | UC46 Split payment | UC25 Take payment | UC46 trigger: "Extends UC25 at step 3 when the cashier selects Kết hợp" |
  | UC28 View & share receipt | UC35 View order history | UC35 alt 3a: paid order → "Hóa đơn" |
  | UC27 Cancel order | UC22 Confirm customer order | UC22 alt 3a: "Cashier rejects the order" |
  | UC43 Deduct cancel waste | UC27 Cancel order | BR-INV-02: cancelled order whose drinks were already made |
  | UC31 Notify order ready | UC30 Process order queue | UC30 step 5: status = ready |
  | UC33 Track order status | UC32 Order via table QR | UC32 alt 6a: "Order tracking (P2) is built" |
  | UC37 Export report | UC36 View sales reports | UC36 alt 5a: "Manager taps Xuất" |

- **Actor generalization.** `Staff` is abstract; `Cashier`, `Barista` and `Manager` specialize it
  (drawn on D1 only). Per brief §2, `Manager` also holds every Cashier and Barista permission; this
  is not drawn, so D3 and D5 show only the lowest role that performs each use case.
- **External actors** are Firebase Auth (UC01, UC03, UC32), Firebase Cloud Messaging (UC16,
  UC31) and VietQR (UC25), drawn to the right of the frame beside the use case that calls them.
- **System use cases.** UC15, UC16, UC31 and UC43 have no human primary actor: UC15 is reached only
  through `<<include>>` from UC25, UC16 / UC31 are extensions that talk to Firebase Cloud
  Messaging, and UC43 extends UC27 when the cancelled drinks were already made.
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
| `erd.drawio` | SRS §3.1.5 / SDS data | Entity relationship diagram of the Firestore model (brief §9.2, crow's foot); dashed entities are embedded arrays / maps |
| `screen-mockups.drawio` | SRS §3.2 | Low-fidelity wireframes, one page per screen S01–S22 (brief §8); `b` / `c` / `d` pages are further states of the same screen |

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
