## Store

---

### FAQ

##### 1. Store XML Structure

```xml
<store>
  <category>
      <offer />
      <offer />
  </category>

  <category>
    <subcategory>
      <offer />
      <offer />
    </subcategory>
  </category>
</store>
```

### Category Options

| Field Name | Type            | Usage                       | Default   |
| ---------- | --------------- | --------------------------- | --------- |
| name       | string          | category name               | Mandatory |
| icon       | string          | category icon name          | Mandatory |
| rookgaard  | string (yes/no) | category is allowed in rook | yes       |

#### Example :

```xml
<category name="Premium Time" icon="Category_PremiumTime.png" rookgaard="yes" />
```

### Subcategory Options

| Field Name | Type            | Usage                          | Default   |
| ---------- | --------------- | ------------------------------ | --------- |
| name       | string          | subcategory name               | Mandatory |
| icon       | string          | subcategory icon name          | Mandatory |
| rookgaard  | string (yes/no) | subcategory is allowed in rook | yes       |
| state      | string          | subcategory highlight state    | none      |

### State types

| State Options |
| ------------- |
| none          |
| new           |
| sale          |
| timed         |

#### Example :

```xml
<subcategory name="Casks" icon="Category_Casks.png" rookgaard="yes" state="none">
</subcategory>
```

### Offer Options

#### Mandatory Fields

| Method  | Type         | Usage                                |
| ------- | ------------ | ------------------------------------ |
| name    | string       | offer name                           |
| icon    | string       | offer icon name                      |
| offerId | unsigned int | offer identifier                     |
| price   | unsigned int | offer price                          |
| type    | string       | offer type (possible options below)  |
| state   | string       | offer state (possible options below) |

### Offer types

|           |            | Type Options |               |                |
| --------- | ---------- | ------------ | ------------- | -------------- |
| none      | mount      | preyslot     | pounch        | namechange     |
| item      | namechange | preybonus    | allblessings  | sexchange      |
| stackable | sexchange  | temple       | instantreward | hirelingskill  |
| charges   | house      | bleesings    | charms        | hirelingoutfit |
| outfit    | expboost   | premium      | hireling      | huntingslot    |

#### Optional Fields

| Method      | Type         | Usage             | Default |
| ----------- | ------------ | ----------------- | ------- |
| count       | unsigned int | offer count       | 1       |
| validUntil  | unsigned int | offer validUntil  | 0       |
| coinType    | string       | offer coin type   | coin    |
| description | string       | offer description | ""      |
| movable     | string       | offer movable     | false   |

### Coin types

| Coin Options |
| ------------ |
| coin         |
| transferable |
| tournament   |

#### Example :

```XML
<offer name="Strong Health Cask" icon="Strong_Health_Cask.png" offerId="25880" price="11" type="house" movable="true" state="none" count="1000" description="" />
```
