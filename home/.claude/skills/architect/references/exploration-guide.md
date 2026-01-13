# Codebase Exploration Guide

## Exploration Approach

Use Task tool with subagent_type=Explore for broad discovery:

- Architecture patterns
- Related functionality locations
- Component dependencies
- Testing approaches
- Common patterns in codebase

Use direct tools (Glob/Grep/Read) for specific targets:

- Known file patterns
- Specific function/class names
- Configuration files

## Discovery Checklist

### 1. Related Code
- Existing similar features
- Shared utilities/helpers
- Common patterns to follow

### 2. Architecture
- Project structure
- Module boundaries
- Data flow patterns
- State management approach

### 3. Testing
- Test file locations
- Testing frameworks used
- Coverage expectations
- Example test patterns

### 4. Dependencies
- Affected components
- Integration points
- Shared interfaces
- Breaking change risks

### 5. Configuration
- Environment setup
- Feature flags
- Build/deploy requirements
- Database migrations

## Exploration Depth

**Light exploration** (simple features):
- Identify 2-3 related files
- Understand basic patterns
- Check test approach

**Medium exploration** (most features):
- Map component dependencies
- Identify integration points
- Review similar implementations
- Check architectural boundaries

**Deep exploration** (complex/cross-cutting):
- Full dependency analysis
- Architecture implications
- Migration requirements
- Multiple component coordination
