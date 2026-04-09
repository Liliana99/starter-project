# Database Schema: Articles & Tags

This schema defines the structure for the News App's journalist functionality, supporting dynamic tagging and rich text content.

## 1. Collection: `articles`
| Field Name      | Type      | Constraints / Validation           | Description                                  |
|:----------------|:----------|:-----------------------------------|:---------------------------------------------|
| `id`            | String    | Firestore Auto-ID                  | Unique article identifier.                   |
| `title`         | String    | Required, Max 100 chars            | Headline for the feed.                       |
| `content`       | String    | Required, Markdown, Max 30k chars  | Main body of the news.                       |
| `thumbnail_url` | String    | Required, Valid HTTPS URL          | Link to Firebase Storage asset.              |
| `author_id`     | String    | Required, Firebase Auth UID        | Owner of the article.                        |
| `tag_ids`       | Array     | List of Strings (Tag IDs)          | References to the `tags` collection.         |
| `status`        | String    | Enum: `['draft', 'published']`     | Current publishing state.                    |
| `created_at`    | Timestamp | Server-generated                   | Creation date for sorting.                   |
| `avg_read_time` | Number    | Min: 1                             | Calculated based on word count.              |

## 2. Collection: `tags`
| Field Name    | Type   | Constraints / Validation      | Description                                |
|:--------------|:-------|:------------------------------|:-------------------------------------------|
| `id`          | String | Required, Lowercase, No spaces| Unique tag ID (e.g., 'tech-news').         |
| `label`       | String | Required, Max 30 chars        | Display name (e.g., 'Tech News').          |
| `usage_count` | Number | Default: 1                    | Counter for popular tags analytics.        |

## 3. Collection: `authors`
| Field Name      | Type      | Constraints / Validation           | Description                                  |
|:----------------|:----------|:-----------------------------------|:---------------------------------------------|
| `author_id`     | String    | Firestore Auto-ID                  | Unique user identifier.                      |
| `full_name`     | String    | Required, Max 100 chars            | Headline for the feed.                       |
| `prof_title`    | String    | Required, Max 50 chars             | Role or specialty (e.g., 'Senior Editor').   |
| `email`         | String    | Required, Valid HTTPS URL          | Main body of the news.                       |
| `profile_image` | String    | Required, Valid HTTPS URL          | Link to Firebase Storage asset.              |
| `bio`           | String    | Required, Firebase Auth UID        | Owner of the article.                        |
| `social_links`  | Array     | List of Strings (Tag IDs)          | References to the `tags` collection.         |
| `status`        | String    | Enum: ['active', 'inactive']       | Current publishing state.                    |
| `created_at`    | Timestamp | Server-generated                   | Creation date for sorting.                   |
| `updated_at`    | Timestamp | Server-generated                   | Creation date for sorting.                   |



## 4. Storage Hierarchy
- **Path:** `media/articles/`
- **Rules:** Only authenticated users can upload. Images must be < 5MB.

---

## Symmetry Implementation Standards
- **Maximally Overdeliver:** Added `avg_read_time` and `usage_count` to provide extra value for the UI and data analytics.