# pgai on Railway

### TL;DR: Template to run [pgai](https://github.com/timescale/pgai) on [Railway](https://railway.com).

Running [pgai](https://github.com/timescale/pgai) directly from the official docker image was causing permission issues—this template aims to resolve that and help others get started!

### Notes:

- Built on [timescale/timescaledb-ha:pg17](https://hub.docker.com/r/timescale/timescaledb-ha).
- Uses OpenAI (you'll need your `OPENAI_API_KEY`).
- No vectorizer service included.
- Contains the following PostgreSQL extensions:
  - vector
  - pgai
  - vectorscale

---

## What is pgai?

`pgai` is an extension that enables running AI commands directly from within PostgreSQL.  
Example: To get embeddings for a phrase:

```sql
SELECT ai.openai_embed('text-embedding-3-small', 'Hello world!', dimensions=>1536);
```

For more details, check out the pgai [documentation](https://github.com/timescale/pgai).

---

## Quick Start

1. Deploy the template on [Railway](https://railway.app).
2. Connect to your database using the provided environment variables.
3. Enable the desired extensions on your database:

```sql
CREATE EXTENSION IF NOT EXISTS pgai CASCADE;
CREATE EXTENSION IF NOT EXISTS vectorscale CASCADE;
```

Your PostgreSQL instance is now ready to use with pgai and vectorscale!

---

## Test the Setup

1. Follow the Quick Start steps above.
2. Create a test table:

```sql
CREATE TABLE blog (
    id SERIAL PRIMARY KEY,
    title TEXT,
    authors TEXT,
    contents TEXT,
    metadata JSONB,
    vector vector(1536)
);
```

3. Insert sample data:

```sql
INSERT INTO blog (title, authors, contents, metadata)
VALUES
('Getting Started with PostgreSQL', 'John Doe', 'PostgreSQL is a powerful, open source object-relational database system...', '{"tags": ["database", "postgresql", "beginner"], "read_time": 5, "published_date": "2024-03-15"}'),
('10 Tips for Effective Blogging', 'Jane Smith, Mike Johnson', 'Blogging can be a great way to share your thoughts and expertise...', '{"tags": ["blogging", "writing", "tips"], "read_time": 8, "published_date": "2024-03-20"}'),
('The Future of Artificial Intelligence', 'Dr. Alan Turing', 'As we look towards the future, artificial intelligence continues to evolve...', '{"tags": ["AI", "technology", "future"], "read_time": 12, "published_date": "2024-04-01"}'),
('Healthy Eating Habits for Busy Professionals', 'Samantha Lee', 'Maintaining a healthy diet can be challenging for busy professionals...', '{"tags": ["health", "nutrition", "lifestyle"], "read_time": 6, "published_date": "2024-04-05"}'),
('Introduction to Cloud Computing', 'Chris Anderson', 'Cloud computing has revolutionized the way businesses operate...', '{"tags": ["cloud", "technology", "business"], "read_time": 10, "published_date": "2024-04-10"}');
```

4. Create embeddings:

```sql
UPDATE blog
SET vector = ai.openai_embed('text-embedding-3-small', title || ' - ' || contents, dimensions=>1536);
```

5. Find matching documents:

```sql
SELECT *
FROM blog
ORDER BY cosine_distance(vector, ai.openai_embed('text-embedding-3-small', 'are eggs healthy', dimensions=>1536))
LIMIT 3;
```

This directly queries OpenAI for embeddings from within PostgreSQL—pure magic! 🤯
