# MCP Workflow

Use this file when XcodeBuildMCP is available.

## Detect Availability

Try `mcp__XcodeBuildMCP__session-show-defaults`. If it succeeds, the MCP path
is available for this session.

## Core MCP Loop

1. `session-show-defaults`
2. `discover_projs` if the project path is unclear
3. `list_schemes`
4. `list_sims`
5. `session-set-defaults`
6. `build_sim` or `build_run_sim`
7. `launch_app_logs_sim`, log capture, or debugger tools when diagnosis needs
   more than a normal run

## Common Tool Set

- `mcp__XcodeBuildMCP__session-show-defaults`
- `mcp__XcodeBuildMCP__discover_projs`
- `mcp__XcodeBuildMCP__list_schemes`
- `mcp__XcodeBuildMCP__list_sims`
- `mcp__XcodeBuildMCP__session-set-defaults`
- `mcp__XcodeBuildMCP__build_run_sim`
- `mcp__XcodeBuildMCP__build_sim`
- `mcp__XcodeBuildMCP__launch_app_sim`
- `mcp__XcodeBuildMCP__launch_app_logs_sim`
- `mcp__XcodeBuildMCP__start_sim_log_cap`
- `mcp__XcodeBuildMCP__stop_sim_log_cap`
- `mcp__XcodeBuildMCP__debug_attach_sim`
- `mcp__XcodeBuildMCP__debug_stack`
- `mcp__XcodeBuildMCP__debug_variables`
